hdfs dfs -mkdir /datasets 

# hdfs dfs -put /datasets/txt/*.txt /datasets/ 
# hdfs dfs -rm -r -f /output/lab2_2025-11-*
# pig -x mapreduce /scripts/lab2.pig
# hdfs dfs -cat /output/lab2_2025-11-*/*

hdfs dfs -put /datasets/*.csv /datasets/ 
hdfs dfs -rm -r -f /output/dz2_2025-11-*
pig -x mapreduce /scripts/dz2.pig
hdfs dfs -cat /output/dz2_2025-11-*/*
