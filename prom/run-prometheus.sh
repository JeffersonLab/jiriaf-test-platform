#!/bin/bash


export HOST_HOME="/home/tsai"


docker run -d \
    --name prometheus \
    --net=host \
    --user "$(id -u)" \
    -v $HOST_HOME/JIRIAF/JIRIAF-test-platform/prom:/prometheus \
    -v $HOST_HOME/JIRIAF/prom-data/data:/prometheus/data \
    -v $HOST_HOME/JIRIAF/prom-data/snapshot:/prometheus/snapshot \
    prom/prometheus --config.file=/prometheus/prometheus.yml --storage.tsdb.path=/prometheus/data --storage.tsdb.retention.time=720d --web.enable-admin-api


      ## Manually open port 9090 in vscode