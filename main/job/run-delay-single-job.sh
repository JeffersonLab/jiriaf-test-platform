#!/bin/bash

# Define the number of pods you want to create
num_pods=2

# Loop to create the pods
for ((i=1; i<=num_pods; i++)); do
  # Use Helm to install the job
  helm install ersap-test3-job$i ersap-helm/single-job/ --set Deployment.name=ersap-test3-job$i

  # Wait for 30 seconds before creating the next pod
  sleep 30
done