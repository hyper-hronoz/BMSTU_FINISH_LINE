bash fuck.sh

docker compose up -d
docker ps

docker cp ./mapred-site.xml dz1-namenode-1:/opt/hadoop/etc/hadoop/mapred-site.xml 
docker cp ./yarn-site.xml dz1-namenode-1:/opt/hadoop/etc/hadoop/yarn-site.xml

docker cp dz1-namenode-1:/opt/hadoop/etc/hadoop ./hadoop-conf

docker exec -it dz1-namenode-1 bash


