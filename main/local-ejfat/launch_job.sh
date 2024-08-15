#!/bin/bash

# Usage: ./launch_job.sh <ID> <INDEX> <SITE> <ersap-exporter-port> <jrm-exporter-port>
if [ "$#" -ne 5 ]; then
  echo "Usage: $0 <ID> <INDEX> <SITE> <ersap-exporter-port> <jrm-exporter-port>"
  exit 1
fi

ID=$1 # jlab-100g-nersc-ornl
INDEX=$2 # 0
SITE=$3 # perlmutter or ornl
ERSAP_EXPORTER_PORT=$4 # 20000
JRM_EXPORTER_PORT=$5 # 10000

# Calculate other ports based on ERSAP_EXPORTER_PORT
PROCESS_EXPORTER_PORT=$((ERSAP_EXPORTER_PORT + 1))
EJFAT_EXPORTER_PORT=$((ERSAP_EXPORTER_PORT + 2))
ERSAP_QUEUE_PORT=$((ERSAP_EXPORTER_PORT + 3))

# Run Helm install
helm install "$ID-job-$INDEX" job/ \
  --set Deployment.site=$SITE \
  --set Deployment.name="$ID-job-$INDEX" \
  --set Deployment.serviceMonitorLabel=$ID \
  --set Service[0].name="ersap-exporter" \
  --set Service[0].protocol="TCP" \
  --set Service[0].port="$ERSAP_EXPORTER_PORT" \
  --set Service[0].originalPort=2221 \
  --set Service[0].path="/metrics" \
  --set Service[0].interval="15s" \
  --set Service[1].name="process-exporter" \
  --set Service[1].protocol="TCP" \
  --set Service[1].port="$PROCESS_EXPORTER_PORT" \
  --set Service[1].originalPort=1776 \
  --set Service[1].path="/metrics" \
  --set Service[1].interval="15s" \
  --set Service[2].name="ejfat-exporter" \
  --set Service[2].protocol="TCP" \
  --set Service[2].port="$EJFAT_EXPORTER_PORT" \
  --set Service[2].originalPort=8088 \
  --set Service[2].path="/metrics" \
  --set Service[2].interval="15s" \
  --set Service[3].name="jrm-exporter" \
  --set Service[3].protocol="TCP" \
  --set Service[3].port="$JRM_EXPORTER_PORT" \
  --set Service[3].originalPort=10000 \
  --set Service[3].path="/metrics/resource" \
  --set Service[3].interval="15s" \
  --set Service[4].name="ersap-queue" \
  --set Service[4].protocol="TCP" \
  --set Service[4].port="$ERSAP_QUEUE_PORT" \
  --set Service[4].originalPort=2222 \
  --set Service[4].path="/metrics/resource" \
  --set Service[4].interval="15s"