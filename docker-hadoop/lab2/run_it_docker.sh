bash /init-hdfs.sh
bash /create_files.sh

chmod +x /mapper_avg_wordlen.py /reducer_avg_wordlen.py

# hadoop jar /opt/hadoop/share/hadoop/tools/lib/hadoop-streaming-*.jar \
#   -input /input \
#   -output /output \
#   -mapper /mapper_avg_wordlen.py \
#   -reducer /reducer_avg_wordlen.py

hadoop jar /opt/hadoop/share/hadoop/tools/lib/hadoop-streaming-*.jar \
  -files /mapper_avg_wordlen.py,/reducer_avg_wordlen.py \
  -input /input \
  -output /output \
  -mapper mapper_avg_wordlen.py \
  -reducer reducer_avg_wordlen.py


echo "✅ Результат:"
hdfs dfs -cat /output/part-00000
