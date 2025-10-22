#!/usr/bin/env python
# mapper_avg_wordlen.py (Python 2)

import sys
import os
import re

for line in sys.stdin:
    line = line.strip()
    words = re.findall(r'\w+', line)
    if not words:
        continue
    filename = os.environ.get('map_input_file', 'unknown')
    for word in words:
        print "{0}\t{1}".format(filename, len(word))

