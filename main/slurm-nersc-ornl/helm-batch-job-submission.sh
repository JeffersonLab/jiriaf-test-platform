#!/bin/bash

# Base values (customize as needed)
ID="demo"
SITE="perlmutter" # ornl
ERSAP_EXPORTER_PORT_BASE=20000
JRM_EXPORTER_PORT_BASE=10000

# Wait for at least 100 Ready nodes containing "perlmutter" in their name
echo "Waiting for at least 100 Ready nodes with 'perlmutter' in their name..."
while true; do
  READY_NODES=$(kubectl get nodes --no-headers | grep perlmutter | grep -w Ready | wc -l)
  if [ "$READY_NODES" -ge 100 ]; then
    echo "Found $READY_NODES Ready 'perlmutter' nodes. Proceeding with job submission."
    break
  else
    echo "Currently $READY_NODES Ready 'perlmutter' nodes. Waiting..."
    sleep 30
  fi
done

# Phase 1: Start 10 jobs
for ((i=0; i<10; i++)); do
  INDEX="$SITE-$i"
  ERSAP_EXPORTER_PORT=$((ERSAP_EXPORTER_PORT_BASE + i * 4))
  JRM_EXPORTER_PORT=$((JRM_EXPORTER_PORT_BASE + i))

  echo "[Phase 1] Launching job $INDEX"
  ./launch_job.sh "$ID" "$INDEX" "$SITE" "$ERSAP_EXPORTER_PORT" "$JRM_EXPORTER_PORT"
done

echo "Waiting 5 minutes before ramping up to 100 jobs..."
sleep 300

# Phase 2: Ramp up to 100 jobs (jobs 10 to 99)
for ((i=10; i<100; i++)); do
  INDEX="$SITE-$i"
  ERSAP_EXPORTER_PORT=$((ERSAP_EXPORTER_PORT_BASE + i * 4))
  JRM_EXPORTER_PORT=$((JRM_EXPORTER_PORT_BASE + i))

  echo "[Phase 2] Launching job $INDEX"
  ./launch_job.sh "$ID" "$INDEX" "$SITE" "$ERSAP_EXPORTER_PORT" "$JRM_EXPORTER_PORT"
done

echo "All jobs submitted." 