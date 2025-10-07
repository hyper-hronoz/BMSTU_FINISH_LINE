#!/usr/bin/env python
# -*- coding: utf-8 -*-

import subprocess
import sys

def read_hdfs_file(path):
    """Возвращает содержимое HDFS файла как список строк"""
    try:
        output = subprocess.check_output(
            ["hdfs", "dfs", "-cat", path],
            stderr=subprocess.STDOUT
        )
        # В Python 2 output - bytes, декодируем в utf-8
        if isinstance(output, bytes):
            output = output.decode('utf-8')
        return output.splitlines()
    except subprocess.CalledProcessError:
        print "❌ Ошибка: невозможно прочитать {}".format(path)
        sys.exit(1)

def main():
    if len(sys.argv) != 3:
        print "Использование: python compare_hdfs_files.py <HDFS_file1> <HDFS_file2>"
        sys.exit(1)

    file1, file2 = sys.argv[1], sys.argv[2]

    print "🔍 Сравнение файлов:\n  1️⃣ {}\n  2️⃣ {}".format(file1, file2)

    lines1 = read_hdfs_file(file1)
    lines2 = read_hdfs_file(file2)

    if lines1 == lines2:
        print "✅ Файлы идентичны"
    else:
        print "⚠️  Файлы различаются!\n"
        max_len = max(len(lines1), len(lines2))
        for i in range(max_len):
            line1 = lines1[i] if i < len(lines1) else "<no line>"
            line2 = lines2[i] if i < len(lines2) else "<no line>"
            if line1 != line2:
                print "🔸 Строка {} отличается:\n  File1: {}\n  File2: {}".format(i+1, line1, line2)

if __name__ == "__main__":
    main()

