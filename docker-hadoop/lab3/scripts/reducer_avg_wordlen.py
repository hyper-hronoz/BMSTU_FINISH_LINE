#!/usr/bin/env python2
# reducer_avg_wordlen.py

import sys

current_file = None
total_len = 0
word_count = 0

for line in sys.stdin:
    line = line.strip()
    if not line:
        continue
    try:
        filename, val = line.split('\t')
        length_sum, count = map(int, val.split(','))
    except ValueError:
        continue  # skip malformed lines

    if current_file and filename != current_file:
        avg = float(total_len) / word_count if word_count else 0
        print "{0}@{1}".format(int(avg), current_file)
        total_len = 0
        word_count = 0

    current_file = filename
    total_len += length_sum
    word_count += count

# Print last file
if current_file:
    avg = float(total_len) / word_count if word_count else 0
    print "{0}@{1}".format(int(avg), current_file)

