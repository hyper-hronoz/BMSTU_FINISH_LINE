hdfs dfs -mkdir -p /input
hdfs dfs -put -f /data/*.txt /input

hdfs dfs -rm -r -f /output
