#!/bin/bash

# Usage: ./launch_job.sh <ID> <INDEX> <ersap-exporter-port> <jrm-exporter-port>
if [ "$#" -ne 4 ]; then
  echo "Usage: $0 <ID> <INDEX> <ersap-exporter-port> <jrm-exporter-port>"
  exit 1
fi

ID=$1 # jlab-100g-nersc-ornl
INDEX=$2 # 0
ERSAP_EXPORTER_PORT=$3 # 20000
JRM_EXPORTER_PORT=$4 # 10000

# Calculate other ports based on ERSAP_EXPORTER_PORT
PROCESS_EXPORTER_PORT=$((ERSAP_EXPORTER_PORT + 1))
EJFAT_EXPORTER_PORT=$((ERSAP_EXPORTER_PORT + 2))
ERSAP_QUEUE_PORT=$((ERSAP_EXPORTER_PORT + 3))

# Function to update a specific port in values.yaml
update_port() {
  local service_index=$1
  local new_port=$2
  awk -v idx="$service_index" -v port="$new_port" '
    $1 == "Service["idx"].port:" { $2 = port }
    { print }
  ' values.yaml > values.tmp && mv values.tmp values.yaml
}

# Update values.yaml
update_port 0 $ERSAP_EXPORTER_PORT
update_port 1 $PROCESS_EXPORTER_PORT
update_port 2 $EJFAT_EXPORTER_PORT
update_port 3 $JRM_EXPORTER_PORT
update_port 4 $ERSAP_QUEUE_PORT

# Run Helm install
helm install "$ID-job-$INDEX" job/ \
  --set Deployment.name="$ID-job-$INDEX" \
  --set Deployment.serviceMonitorLabel=$ID