#!/bin/bash

# Wait for the NameNode to fully start
sleep 1

echo "Creating HDFS directories..."
hdfs dfs -mkdir -p /user/hduser/Hadoop

# Create a file with your name and group
FILE_NAME="MoryakovVY_IUK472B.txt"
echo -e "Hello!\nThis is a test file.\nHDFS automation with Docker." > /tmp/$FILE_NAME
hdfs dfs -put -f /tmp/$FILE_NAME /user/hduser/Hadoop/

# Check the created directories and files
echo "HDFS state after automation:"
hdfs dfs -ls -R /user/hduser

echo "HDFS automation completed!"

