bash /init-hdfs.sh
bash /create_files.sh

hadoop jar /opt/hadoop/share/hadoop/tools/lib/hadoop-streaming-*.jar \
  -files /scripts/mapper_avg_wordlen.py,/scripts/reducer_avg_wordlen.py,/scripts/combiner_sum_count.py \
  -input /input \
  -output /output \
  -mapper mapper_avg_wordlen.py \
  -combiner combiner_sum_count.py \
  -reducer reducer_avg_wordlen.py

echo "✅ Результат:"
hdfs dfs -cat /output/part-00000
