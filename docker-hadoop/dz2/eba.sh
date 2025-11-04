docker compose up -d

docker ps -aq | xargs docker rm -f

docker cp ./hdfs-site.xml namenode:/opt/hadoop-3.2.1/etc/hadoop/hdfs-site.xml
