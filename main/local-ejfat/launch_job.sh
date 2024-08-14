#!/bin/bash

# Usage: ./launch_job.sh <ID> <INDEX> <ersap-exporter-port> <jrm-exporter-port>
if [ "$#" -ne 4 ]; then
  echo "Usage: $0 <ID> <INDEX> <ersap-exporter-port> <jrm-exporter-port>"
  exit 1
fi

ID=$1 #jlab-100g-nersc-ornl
INDEX=$2 #0
ERSAP_EXPORTER_PORT=$3 #20000
JRM_EXPORTER_PORT=$4 #10000

# Calculate other ports based on ERSAP_EXPORTER_PORT
PROCESS_EXPORTER_PORT=$((ERSAP_EXPORTER_PORT + 1))
EJFAT_EXPORTER_PORT=$((ERSAP_EXPORTER_PORT + 2))
ERSAP_QUEUE_PORT=$((ERSAP_EXPORTER_PORT + 3))

helm install "$ID-job-$INDEX" job/ \
  --set Deployment.name="$ID-job-$INDEX" \
  --set Deployment.serviceMonitorLabel=$ID \
  --set Service[0].port="$ERSAP_EXPORTER_PORT" \
  --set Service[0].name="ersap-exporter" \
  --set Service[0].containerPort="$ERSAP_EXPORTER_PORT" \
  --set Service[1].port="$PROCESS_EXPORTER_PORT" \
  --set Service[1].name="process-exporter" \
  --set Service[1].containerPort="$PROCESS_EXPORTER_PORT" \
  --set Service[2].port="$EJFAT_EXPORTER_PORT" \
  --set Service[2].name="ejfat-exporter" \
  --set Service[2].containerPort="$EJFAT_EXPORTER_PORT" \
  --set Service[3].port="$JRM_EXPORTER_PORT" \
  --set Service[3].name="jrm-exporter" \
  --set Service[3].containerPort="$JRM_EXPORTER_PORT" \
  --set Service[4].port="$ERSAP_QUEUE_PORT" \
  --set Service[4].name="ersap-queue" \
  --set Service[4].containerPort="$ERSAP_QUEUE_PORT"