#!/bin/bash

DATA_COUNT=$(kubectl logs $1 | grep time | wc -l)

if [ $# -eq 0 ]; then
    echo "Usage: rabbitmq_data_generator [performance tool pod name with namespace]" && exit 1
fi

if [ $DATA_COUNT -lt 560 ]; then
    echo "Wait and try run tool again due to data set is not allocated enough, current is $DATA_COUNT" && exit 1
fi


kubectl logs $1 | grep time | awk -F, '{ print $2 $3 $4 }' | awk -F' ' '{printf("%s,%s,%s\n", $2, $4, $7)}' | awk 'BEGIN{print ", Producer, Consumer"}1' > /tmp/rabbitmq-perf-$(date +"%FT%T").csv

echo "finish... please find report in /tmp/rabbitmq-perf-xxx.csv"
