# Alpine Docker Image with InfluxDB and Grafana


## Versions

* Alpine:            3.7
* InfluxDB:          1.5.1
* Grafana:           5.0.4


To build the Docker image:

```
docker build -t docker-alpine-influxdb-grafana .
```

To start the container:
```
docker run \
       --name docker-alpine-influxdb-grafana \
       -p 3000:3000 \
       -p 8083:8083 \
       -p 8086:8086 \
       -p 8125:8125/udp \
       -v <path_to_grafana_data>:/grafana/ \
       -v <path_to_influxdb_conf>:/etc/influxdb \
       -v <path_to_influxdb_data>:/var/lib/influxdb \
       docker-alpine-influxdb-grafana
```

To stop the container:

```
docker stop docker-alpine-influxdb-grafana
```

To remove the container:

```
docker rm docker-alpine-influxdb-grafana
```

## Ports

```
Container       Service 

3000            grafana     
8083            influxdb-admin 
8086            influxdb 
```


## Grafana

Open <http://localhost:3000>

Username: admin
Password: admin


## Convenience scripts

To generate a local folder with default configuration for Grafana & InfluxDB:

```
./create_default_configs.sh 
```

To run the locally built image:

```
./run_local.sh 
```

To run a pre-built built image:

```
./run_prebuilt.sh 
```

To install the InfluxDB datasource:

```
./install_influxdb_datasource.sh
```

To push some data in:

```
python simple_influxdb_client.py
```

A sample dashboard can be created by importing ```./dashboards/SampleDashboard.json```