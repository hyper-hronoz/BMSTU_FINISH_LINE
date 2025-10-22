# docker cp namenode:/opt/hadoop/etc/hadoop ./hadoop-conf
#
# /opt/spark/bin/spark-submit \
#   --master yarn \
#   --deploy-mode cluster \
#   /opt/compare_hdfs_files.py
#

export PYSPARK_PYTHON=python3
export PYSPARK_DRIVER_PYTHON=python3

/opt/spark/bin/spark-submit \
  --master yarn \
  --deploy-mode client \
  /opt/compare_hdfs_files.py
