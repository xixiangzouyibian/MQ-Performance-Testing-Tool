#!/bin/bash

if [ "$1" ]; then
  REPORT_DIR=$1
else
  REPORT_DIR=./
fi

cd ${REPORT_DIR}
PRODUCER_REPORT=JmsProducer.xml
CONSUMER_REPORT=JmsConsumer.xml
PARSED_DIR=parsed_report
TIME=`date +"%FT%T"`
REPORT_FILE=amq-perf-${TIME}.csv

FILE_COUNT=`ls $PRODUCER_REPORT $CONSUMER_REPORT | wc -l`

if [ $FILE_COUNT -ne 2 ]; then
    echo "Please check if producer and consumer is prepared for the current path, and if both are unique!" && exit 1
fi

paste <(grep tpdata ${PRODUCER_REPORT} | awk -F' ' '{print $2 $4}' | awk -F\' '{printf("%0s,%5s,\n", $2, $4)}' | column -t) <(grep tpdata ${CONSUMER_REPORT}| awk -F' ' '{print $2 $4}' | awk -F\' '{printf("%0s\n", $4)}' | column -t) | column -s $'\t' -tne | awk 'BEGIN{print ", Producer, Consumer"}1' > ${REPORT_FILE}

mkdir -p ${PARSED_DIR}

mv ${PRODUCER_REPORT} ${PARSED_DIR}/JmsProducer.xml.${TIME}
mv ${CONSUMER_REPORT} ${PARSED_DIR}/JmsConsumer.xml.${TIME}

echo "finish... please find report in ./amq-perf-xxx.csv"
