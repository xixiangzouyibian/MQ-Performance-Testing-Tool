# MQ-Performance-Testing-Tool

- The tool which can filter, extract and merge data into csv files, benefit us to generate diagram.
- The tool is used in RabbitMQ pivotalrabbitmq/perf-test and ActiveMQ activemq-perf-maven-plugin

For rabbitmq_data_generator.sh(allocate data from xml report files):
1. Running like: #./rabbitmq_data_generator.sh [POD NAME]
2. Find the output in "/tmp/rabbitmq-perf-xxx.csv"

For amq-data_generator.sh (allocate data from perf-test pod):
1. Running like: #./amq_data_generator [REPORT PATH]
2. Find the output in "./report/amq-perf-xxx.csv"
