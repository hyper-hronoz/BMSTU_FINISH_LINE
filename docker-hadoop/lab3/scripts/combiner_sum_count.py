#!/usr/bin/env python2
# combiner_sum_count.py

import sys

current_file = None
total_len = 0
word_count = 0

for line in sys.stdin:
    line = line.strip()
    filename, length = line.split('\t')
    length = int(length)

    if current_file and filename != current_file:
        # Output partial sum and count
        print "{0}\t{1},{2}".format(current_file, total_len, word_count)
        total_len = 0
        word_count = 0

    current_file = filename
    total_len += length
    word_count += 1

if current_file:
    print "{0}\t{1},{2}".format(current_file, total_len, word_count)

