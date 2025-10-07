#!/bin/bash

# Wait for the NameNode to fully start
sleep 1

echo "Creating HDFS directories..."
hdfs dfs -mkdir -p /user/hduser/Hadoop

# Create a file with your name and group
FILE_NAME="MoryakovVY_IUK472B.txt"
echo -e "Hello!\nThis is a test file.\nHDFS automation with Docker." > /tmp/$FILE_NAME
hdfs dfs -put -f /tmp/$FILE_NAME /user/hduser/Hadoop/

# Create a new local file
LOCAL_FILE="new_file.txt"
echo -e "This is a new file\nContents of the new file" > /tmp/$LOCAL_FILE

# Copy the new file into HDFS
hdfs dfs -put -f /tmp/$LOCAL_FILE /user/hduser/Hadoop/

# Set access permissions
hdfs dfs -chmod 770 /user/hduser/Hadoop/$FILE_NAME
hdfs dfs -chmod 770 /user/hduser/Hadoop/$LOCAL_FILE

# Check the created directories and files
echo "HDFS state after automation:"
hdfs dfs -ls -R /user/hduser

echo "HDFS automation completed!"

