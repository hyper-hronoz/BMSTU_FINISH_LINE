bash-4.2$ hadoop fs -cat /input/* | python2 /scripts/mapper_avg_wordlen.py | python2 /scripts/combiner_sum_count.py | python2 /scripts/reducer_avg_wordlen.py

