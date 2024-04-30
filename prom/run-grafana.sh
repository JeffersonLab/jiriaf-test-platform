#!/bin/bash

export HOST_HOME="/home/tsai"

docker run -d --net=host --user "$(id -u)"\
 -e "GF_SERVER_HTTP_PORT=3001" \
 --name grafana \
 --volume $HOST_HOME/JIRIAF/prom-data/grafana-data:/var/lib/grafana\
  grafana/grafana-enterprise \

## Manually open port 3000 in vscode