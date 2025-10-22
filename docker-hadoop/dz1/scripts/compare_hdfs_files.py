from pyspark import SparkContext, SparkConf

def normalize(line):
    return [word.lower() for word in line.split() if word.isalpha()]

if __name__ == "__main__":
    conf = SparkConf().setAppName("CompareTwoFiles")
    sc = SparkContext(conf=conf)

    file1 = "hdfs:///files/file1.txt"
    file2 = "hdfs:///files/file2.txt"

    words1 = sc.textFile(file1).flatMap(normalize).map(lambda w: (w, 1))
    words2 = sc.textFile(file2).flatMap(normalize).map(lambda w: (w, 1))

    counts1 = words1.reduceByKey(lambda a, b: a + b)
    counts2 = words2.reduceByKey(lambda a, b: a + b)

    common = counts1.join(counts2)

    common_total = common.map(lambda x: (x[1][0] + x[1][1], x[0]))

    common_total.saveAsTextFile("hdfs:///data/common_words")

    sc.stop()

