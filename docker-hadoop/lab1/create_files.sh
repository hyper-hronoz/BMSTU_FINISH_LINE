# Пути в HDFS
HDFS_DIR="/user/hduser/compare_test"

echo "=== Создание тестовых файлов ==="

# Создаём два файла локально
FILE1="/tmp/file1.txt"
FILE2="/tmp/file2.txt"

echo -e "Hello Hadoop!\nThis is file 1." > $FILE1
echo -e "Hello Hadoop!\nThis is file 2." > $FILE2

hdfs dfs -mkdir -p /tmp
hdfs dfs -put /tmp/file1.txt /tmp/file1.txt
hdfs dfs -put /tmp/file2.txt /tmp/file2.txt

echo "Созданы файлы:"
ls -l $FILE1 $FILE2


