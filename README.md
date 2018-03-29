# Alpine Docker Image with InfluxDB and Grafana


## Versions

* Alpine:            3.7
* InfluxDB:          1.5.1
* Grafana:           5.0.5


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
       docker-alpine-influxdb-grafana
```

To stop the container:

```
docker stop docker-alpine-influxdb-grafana
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

