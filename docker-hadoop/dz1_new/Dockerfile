FROM ubuntu:22.04

# --------------------
# Установка зависимостей
# --------------------
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    python3 \
    python3-pip \
    curl \
    wget \
    ssh \
    rsync \
    net-tools \
    vim \
    && rm -rf /var/lib/apt/lists/*

# --------------------
# Установка Hadoop
# --------------------
ENV HADOOP_VERSION=3.3.6
ENV HADOOP_HOME=/opt/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

RUN wget https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz -O /tmp/hadoop.tar.gz \
    && tar -xzf /tmp/hadoop.tar.gz -C /opt/ \
    && mv /opt/hadoop-$HADOOP_VERSION $HADOOP_HOME \
    && rm /tmp/hadoop.tar.gz

# --------------------
# Установка Apache Spark
# --------------------
ENV SPARK_VERSION=3.5.6
ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

RUN wget https://downloads.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz -O /tmp/spark.tgz \
    && tar -xzf /tmp/spark.tgz -C /opt/ \
    && mv /opt/spark-${SPARK_VERSION}-bin-hadoop3 $SPARK_HOME \
    && rm /tmp/spark.tgz

# --------------------
# Настройка Python для Spark
# --------------------
RUN pip3 install pyspark

# --------------------
# Настройка SSH для Hadoop
# --------------------
RUN ssh-keygen -t rsa -P "" -f /root/.ssh/id_rsa \
    && cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

# --------------------
# Копирование скрипта и файлов
# --------------------
COPY spark_app.py /opt/spark_app.py
COPY entrypoint.sh /entrypoint.sh
COPY files /files

RUN chmod +x /entrypoint.sh

EXPOSE 9870 8088 50070 9000

ENTRYPOINT ["/entrypoint.sh"]

