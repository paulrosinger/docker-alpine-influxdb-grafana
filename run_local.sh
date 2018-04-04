#!/usr/bin/env bash






docker run -d \
       --name docker-alpine-influxdb-grafana \
       -p 3000:3000 \
       -p 8083:8083 \
       -p 8086:8086 \
       -p 8125:8125/udp \
       -v $PWD/local_data/grafana:/grafana \
       -v $PWD/local_data/influxdb/conf:/etc/influxdb \
       -v $PWD/local_data/influxdb/data:/var/lib/influxdb \
       docker-alpine-influxdb-grafana