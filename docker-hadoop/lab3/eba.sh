bash fuck.sh

docker compose up -d
docker ps

docker cp ./mapred-site.xml lab3-namenode-1:/opt/hadoop/etc/hadoop/mapred-site.xml 
docker cp ./yarn-site.xml lab3-namenode-1:/opt/hadoop/etc/hadoop/yarn-site.xml

docker exec -it lab3-namenode-1 bash


