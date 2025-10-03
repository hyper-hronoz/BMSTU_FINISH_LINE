import subprocess
import sys

file1 = "/user/hduser/Hadoop/file1.txt"
file2 = "/user/hduser/Hadoop/file2.txt"

def read_hdfs_file(path):
    """Возвращает содержимое HDFS файла как список строк"""
    try:
        result = subprocess.run(
            ["hdfs", "dfs", "-cat", path],
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout.splitlines()
    except subprocess.CalledProcessError:
        print(f"Error: Cannot read {path}")
        sys.exit(1)

lines1 = read_hdfs_file(file1)
lines2 = read_hdfs_file(file2)

if lines1 == lines2:
    print("Files are identical")
else:
    print("Files differ:")
    max_len = max(len(lines1), len(lines2))
    for i in range(max_len):
        line1 = lines1[i] if i < len(lines1) else "<no line>"
        line2 = lines2[i] if i < len(lines2) else "<no line>"
        if line1 != line2:
            print(f"Line {i+1} differs:\n  File1: {line1}\n  File2: {line2}")

