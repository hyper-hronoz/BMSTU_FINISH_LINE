package com.example.recommender;

import org.apache.mahout.cf.taste.common.TasteException;
import org.apache.mahout.cf.taste.impl.model.file.FileDataModel;
import org.apache.mahout.cf.taste.impl.neighborhood.NearestNUserNeighborhood;
import org.apache.mahout.cf.taste.impl.recommender.GenericUserBasedRecommender;
import org.apache.mahout.cf.taste.impl.recommender.svd.ALSWRFactorizer;
import org.apache.mahout.cf.taste.impl.recommender.svd.SVDRecommender;
import org.apache.mahout.cf.taste.impl.similarity.PearsonCorrelationSimilarity;
import org.apache.mahout.cf.taste.model.DataModel;
import org.apache.mahout.cf.taste.neighborhood.UserNeighborhood;
import org.apache.mahout.cf.taste.recommender.RecommendedItem;
import org.apache.mahout.cf.taste.recommender.Recommender;
import org.apache.mahout.cf.taste.similarity.UserSimilarity;
import org.apache.mahout.cf.taste.eval.RecommenderBuilder;
import org.apache.mahout.cf.taste.eval.RecommenderEvaluator;
import org.apache.mahout.cf.taste.impl.eval.AverageAbsoluteDifferenceRecommenderEvaluator;
import org.apache.mahout.cf.taste.impl.eval.RMSRecommenderEvaluator;

import java.io.*;
import java.util.List;
import java.util.ArrayList;

public class MovieRecommender {

    public static void main(String[] args) throws Exception {
        System.out.println("=== MovieLens Recommendation System ===");

        String inputFile = "/datasets/ml-32m/ratings.csv"; // путь к исходному файлу
        String outputFile = "ratings_mahout_1000.csv";

        prepareDataFirst1000(inputFile, outputFile);

        DataModel model = new FileDataModel(new File(outputFile));
        System.out.println("Data loaded: " + model.getNumUsers() + " users, " + model.getNumItems() + " movies");

        compareSystems(model);
    }

    // --- Подготовка данных ---
    static void prepareDataFirst1000(String inputPath, String outputPath) throws IOException {
        List<String> lines = readAllLines(inputPath);
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(outputPath))) {
            int start = lines.get(0).startsWith("userId") ? 1 : 0;
            int count = 0;
            int maxLines = 1000;
            for (int i = start; i < lines.size() && count < maxLines; i++) {
                String[] parts = lines.get(i).split(",");
                if (parts.length >= 3) {
                    writer.write(parts[0] + "," + parts[1] + "," + parts[2] + "\n");
                    count++;
                }
            }
            System.out.println("Processed " + count + " lines (first 1000 rows)");
        }
        System.out.println("Data prepared: " + outputPath);
    }

    static List<String> readAllLines(String filePath) throws IOException {
        List<String> lines = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                lines.add(line);
            }
        }
        return lines;
    }

    // --- Сравнение двух систем ---
    static void compareSystems(DataModel model) throws TasteException {
        System.out.println("\n==========================================");
        System.out.println(" RECOMMENDATION SYSTEMS COMPARISON ");
        System.out.println("==========================================");

        showDemoRecommendations(model);
        evaluateSystems(model);
    }

    static void showDemoRecommendations(DataModel model) throws TasteException {
        System.out.println("\n--- DEMO RECOMMENDATIONS ---");

        UserSimilarity userSimilarity = new PearsonCorrelationSimilarity(model);
        UserNeighborhood neighborhood = new NearestNUserNeighborhood(10, userSimilarity, model);
        Recommender clusteringRecommender = new GenericUserBasedRecommender(model, neighborhood, userSimilarity);

        Recommender svdRecommender = new SVDRecommender(model, new ALSWRFactorizer(model, 10, 0.065, 10));

        int[] testUsers = findAvailableUsers(model);
        for (int testUser : testUsers) {
            System.out.println("\nRecommendations for user " + testUser + ":");

            System.out.println("User-Based (as TreeClustering replacement):");
            printRecommendations(clusteringRecommender.recommend(testUser, 3));

            System.out.println("SVD:");
            printRecommendations(svdRecommender.recommend(testUser, 3));

            if (testUser == testUsers[1]) break; // показываем только двух пользователей
        }
    }

    static int[] findAvailableUsers(DataModel model) throws TasteException {
        List<Integer> users = new ArrayList<>();
        for (int i = 1; i <= 10; i++) {
            try {
                if (model.getPreferencesFromUser(i).length() >= 2) {
                    users.add(i);
                }
                if (users.size() >= 3) break;
            } catch (Exception e) {}
        }
        if (users.isEmpty()) {
            users.add(1);
            users.add(2);
        }
        int[] result = new int[users.size()];
        for (int i = 0; i < users.size(); i++) result[i] = users.get(i);
        return result;
    }

    static void printRecommendations(List<RecommendedItem> items) {
        if (items.isEmpty()) System.out.println("  No recommendations");
        else for (RecommendedItem item : items)
            System.out.printf("  Movie %d (score: %.3f)\n", item.getItemID(), item.getValue());
    }

    static void evaluateSystems(DataModel model) throws TasteException {
        System.out.println("\n--- SYSTEM EVALUATION (10 runs) ---");

        int runs = 10;
        double[] results1 = evaluateSystem(model, runs, "User-Based (TreeClustering replacement)",
                new RecommenderBuilder() {
                    public Recommender buildRecommender(DataModel model) throws TasteException {
                        UserSimilarity similarity = new PearsonCorrelationSimilarity(model);
                        UserNeighborhood neighborhood = new NearestNUserNeighborhood(20, similarity, model);
                        return new GenericUserBasedRecommender(model, neighborhood, similarity);
                    }
                });

        double[] results2 = evaluateSystem(model, runs, "SVDRecommender",
                new RecommenderBuilder() {
                    public Recommender buildRecommender(DataModel model) throws TasteException {
                        return new SVDRecommender(model, new ALSWRFactorizer(model, 10, 0.065, 10));
                    }
                });

        System.out.println("\n------------------------------------------");
        System.out.println("FINAL RESULTS (lower = better):");
        System.out.println("------------------------------------------");
        printResults("User-Based (TreeClustering replacement)", results1);
        printResults("SVDRecommender", results2);

        findBestSystem(results1, results2);
    }

    static double[] evaluateSystem(DataModel model, int runs, String name, RecommenderBuilder builder)
            throws TasteException {
        System.out.println("\nEvaluating: " + name);

        RecommenderEvaluator maeEval = new AverageAbsoluteDifferenceRecommenderEvaluator();
        RecommenderEvaluator rmseEval = new RMSRecommenderEvaluator();

        double totalMAE = 0, totalRMSE = 0;
        for (int i = 0; i < runs; i++) {
            try {
                double mae = maeEval.evaluate(builder, null, model, 0.7, 1.0);
                double rmse = rmseEval.evaluate(builder, null, model, 0.7, 1.0);
                totalMAE += mae;
                totalRMSE += rmse;
                System.out.printf("  Run %d: MAE=%.4f, RMSE=%.4f\n", i + 1, mae, rmse);
            } catch (Exception e) {
                System.out.printf("  Run %d: Error in evaluation\n", i + 1);
            }
        }
        return new double[]{totalMAE / runs, totalRMSE / runs};
    }

    static void printResults(String name, double[] results) {
        System.out.printf("%-35s: MAE=%.4f, RMSE=%.4f\n", name, results[0], results[1]);
    }

    static void findBestSystem(double[] res1, double[] res2) {
        String[] names = {"User-Based (TreeClustering replacement)", "SVDRecommender"};
        double[][] all = {res1, res2};

        int bestMAE = res1[0] < res2[0] ? 0 : 1;
        int bestRMSE = res1[1] < res2[1] ? 0 : 1;

        System.out.println("\n==========================================");
        System.out.println("BEST SYSTEMS:");
        System.out.println("==========================================");
        System.out.printf("Best MAE:  %s (%.4f)\n", names[bestMAE], all[bestMAE][0]);
        System.out.printf("Best RMSE: %s (%.4f)\n", names[bestRMSE], all[bestRMSE][1]);
    }
}

