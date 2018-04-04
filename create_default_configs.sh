#!/usr/bin/env bash

rm -fr local_data
mkdir -p local_data
mkdir -p local_data/influxdb/conf
mkdir -p local_data/influxdb/data



docker run -d \
       --name docker-alpine-influxdb-grafana \
       -p 3000:3000 \
       -p 8083:8083 \
       -p 8086:8086 \
       -p 8125:8125/udp \
       docker-alpine-influxdb-grafana


docker cp  docker-alpine-influxdb-grafana:/grafana local_data
docker cp  docker-alpine-influxdb-grafana:/etc/influxdb/influxdb.conf local_data/influxdb/conf
docker cp  docker-alpine-influxdb-grafana:/var/lib/influxdb/meta local_data/influxdb/data
docker cp  docker-alpine-influxdb-grafana:/var/lib/influxdb/data local_data/influxdb/data

docker stop docker-alpine-influxdb-grafana
docker rm docker-alpine-influxdb-grafana

