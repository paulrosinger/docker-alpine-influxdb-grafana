FROM alpine:3.7
MAINTAINER Paul Rosinger <paul.rosinger@gmail.com>

ENV INFLUXDB_VERSION 1.5.1
ENV GRAFANA_VERSION 5.0.4


# Influxdb
# https://github.com/influxdata/influxdata-docker/blob/master/influxdb/1.2/Dockerfile
RUN apk add --no-cache --virtual .build-deps wget gnupg tar ca-certificates && \
    update-ca-certificates && \
    gpg --keyserver hkp://ha.pool.sks-keyservers.net \
        --recv-keys 05CE15085FC09D18E99EFB22684A14CF2582E0C5 && \
    wget -q https://dl.influxdata.com/influxdb/releases/influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz.asc && \
    wget -q https://dl.influxdata.com/influxdb/releases/influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz && \
    gpg --batch --verify influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz.asc influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz && \
    mkdir -p /usr/src && \
    tar -C /usr/src -xzf influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz && \
    rm -f /usr/src/influxdb-*/influxdb.conf && \
    chmod +x /usr/src/influxdb-*/* && \
    cp -a /usr/src/influxdb-*/* /usr/bin/ && \
    rm -rf *.tar.gz* /usr/src /root/.gnupg && \
    apk del .build-deps
VOLUME ["/etc/influxdb"]
EXPOSE 8083 8086


# Grafana
# https://github.com/orangesys/alpine-grafana/blob/master/4.2.0/Dockerfile
ENV GLIBC_VERSION=2.25-r0
ENV GOSU_VERSION=1.10
RUN set -ex \
 && addgroup -S grafana \
 && adduser -S -G grafana grafana \
 && apk add --no-cache ca-certificates openssl fontconfig bash curl \
 && apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/community dumb-init \
 && curl -sL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64 > /usr/sbin/gosu \
 && chmod +x /usr/sbin/gosu  \
 && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub \
 && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
 && apk add glibc-${GLIBC_VERSION}.apk \
 && wget -q https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-$GRAFANA_VERSION.linux-x64.tar.gz \
 && tar -xzf grafana-$GRAFANA_VERSION.linux-x64.tar.gz \
 && mv grafana-$GRAFANA_VERSION/ grafana/ \
 && mv grafana/bin/* /usr/local/bin/ \
 && mkdir -p /grafana/data /grafana/data/plugins /var/lib/grafana/ \
 && ln -s /grafana/data/plugins /var/lib/grafana/plugins \
 && grafana-cli plugins update-all \
 && rm grafana-$GRAFANA_VERSION.linux-x64.tar.gz /etc/apk/keys/sgerrand.rsa.pub glibc-${GLIBC_VERSION}.apk \
 && chown -R grafana:grafana /grafana \
 && apk del curl
VOLUME ["/grafana/conf", "/grafana/data"]
EXPOSE 3000

# Install supervisord
RUN apk --no-cache add supervisor
COPY supervisord/supervisord.conf /etc/supervisord.conf

# Configuration
#COPY telegraf/telegraf.conf /etc/telegraf/telegraf.conf
COPY influxdb/influxdb.conf /etc/influxdb/influxdb.conf

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]

