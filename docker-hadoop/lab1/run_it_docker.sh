bash /init-hdfs.sh
bash /create_files.sh

python /compare_hdfs_files.py /tmp/file1.txt /tmp/file2.txt
