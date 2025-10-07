#!/usr/bin/env python
# reducer_avg_wordlen.py (Python 2)

import sys

current_file = None
total_len = 0
word_count = 0

for line in sys.stdin:
    line = line.strip()
    filename, length = line.split('\t')
    length = int(length)

    if current_file and filename != current_file:
        avg = float(total_len) / word_count if word_count else 0
        print "{0}@{1}".format(int(avg), current_file)
        total_len = 0
        word_count = 0

    current_file = filename
    total_len += length
    word_count += 1

if current_file:
    avg = float(total_len) / word_count if word_count else 0
    print "{0}@{1}".format(int(avg), current_file)

