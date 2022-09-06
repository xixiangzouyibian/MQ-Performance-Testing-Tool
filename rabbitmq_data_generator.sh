#!/bin/bash

STORE_PATH="/tmp/rabbitmq-perf-$(date +"%FT%T").csv"
K8S_LOG="kubectl logs $1"
LOG_COUNT=598
LONG_DURATION=2
SHORT_DURATION=0.1
DURATION_CHANGE_SHORT=false
IS_WARN=false

if [ $# -eq 0 ]; then
    echo "Usage: rabbitmq_data_generator [performance tool pod name with namespace]" && exit 1
fi

while true
do
        LATEST_LINE=$(eval $K8S_LOG | tail)
        if echo $LATEST_LINE | grep -q "test stopped"; then
                eval $K8S_LOG | grep sent | awk -F, '{ print $2 $3 $4 }' | awk -F' ' '{printf("%s,%s,%s\n", $2, $4, $7)}' | awk 'BEGIN{print ", Producer, Consumer"}1' > $STORE_PATH
                eval $K8S_LOG | tail -2 >> $STORE_PATH
				echo "finish... please find report in /tmp/rabbitmq-perf-xxx.csv" && exit 0
        else
			DATA_COUNT=$(eval $K8S_LOG | grep sent | wc -l)
			if [ $DATA_COUNT -gt $LOG_COUNT ] && [ $IS_WARN = false ]; then
				echo "Completed: $(($DATA_COUNT * 100 / 600))%, Will done soon!"
				DURATION_CHANGE_SHORT=true
				IS_WARN=true
			fi
			
			if $DURATION_CHANGE_SHORT; then
				sleep $SHORT_DURATION
			else
				sleep $LONG_DURATION
			fi
        fi
done
