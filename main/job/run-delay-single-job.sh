#!/bin/bash

# Define the number of pods you want to create
num_pods=6

# Loop to create the pods
for ((i=1; i<=num_pods; i++)); do
  # Use Helm to install the job
  helm install job$i single-job/ --set Deployment.name=job$i

  # Wait for 30 seconds before creating the next pod
  sleep 30
done