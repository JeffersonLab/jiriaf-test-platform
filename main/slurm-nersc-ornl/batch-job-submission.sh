#!/bin/bash

# Base values
ID="jlab-100g-nersc-ornl"
SITE="perlmutter" #ornl
ERSAP_EXPORTER_PORT_BASE=20000 #20160
JRM_EXPORTER_PORT_BASE=10000 #10040

# Total number from argument
TOTAL_NUMBER=2

# Loop to run the script from 0 to total number - 1
for ((i=0; i<TOTAL_NUMBER; i++)); do
  INDEX="$SITE-$i"
  ERSAP_EXPORTER_PORT=$((ERSAP_EXPORTER_PORT_BASE + i * 4))
  JRM_EXPORTER_PORT=$((JRM_EXPORTER_PORT_BASE + i))
  
  # print the values
  echo "ID: $ID, INDEX: $INDEX, SITE: $SITE, ERSAP_EXPORTER_PORT: $ERSAP_EXPORTER_PORT, JRM_EXPORTER_PORT: $JRM_EXPORTER_PORT"
  ./launch_job.sh "$ID" "$INDEX" "$SITE" "$ERSAP_EXPORTER_PORT" "$JRM_EXPORTER_PORT"
done