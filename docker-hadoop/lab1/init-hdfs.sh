#!/bin/bash

sleep 1

echo "Creating HDFS directories..."
hdfs dfs -mkdir -p /user/hduser/Hadoop

FILE_NAME="MoryakovVY_IUK472B.txt"
echo -e "Hello!\nThis is a test file.\nHDFS automation with Docker." > /tmp/$FILE_NAME
hdfs dfs -put -f /tmp/$FILE_NAME /user/hduser/Hadoop/

LOCAL_FILE="new_file.txt"
echo -e "This is a new file\nContents of the new file" > /tmp/$LOCAL_FILE

hdfs dfs -put -f /tmp/$LOCAL_FILE /user/hduser/Hadoop/

hdfs dfs -chmod 770 /user/hduser/Hadoop/$FILE_NAME
hdfs dfs -chmod 770 /user/hduser/Hadoop/$LOCAL_FILE

echo "!!!INPUT!!!\n"
hdfs dfs -put -f - /user/hduser/Hadoop/$FILE_NAME

echo "File created. File content:\n"
hdfs dfs -cat  /user/hduser/Hadoop/$FILE_NAME
hdfs dfs -ls /user/hduser/Hadoop/

echo "HDFS state after automation:"
hdfs dfs -ls -R /user/hduser

echo "HDFS automation completed!"


