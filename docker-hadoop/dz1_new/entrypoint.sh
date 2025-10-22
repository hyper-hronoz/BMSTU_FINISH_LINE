#!/bin/bash

# --------------------
# Настройка Hadoop
# --------------------
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export HADOOP_HOME=/opt/hadoop
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
export SPARK_HOME=/opt/spark
export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

# Настройка Hadoop конфигов (simple pseudo-distributed)
cat <<EOL > $HADOOP_CONF_DIR/core-site.xml
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
</configuration>
EOL

cat <<EOL > $HADOOP_CONF_DIR/hdfs-site.xml
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
</configuration>
EOL

# Инициализация HDFS
$HADOOP_HOME/bin/hdfs namenode -format

# Запуск HDFS
$HADOOP_HOME/sbin/start-dfs.sh

# Копирование файлов в HDFS
hdfs dfs -mkdir -p /files
hdfs dfs -put -f /files/* /files/

# Запуск Spark job
spark-submit /opt/spark_app.py

# Держим контейнер активным
tail -f /dev/null

