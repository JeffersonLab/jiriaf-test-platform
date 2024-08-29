#!/bin/bash

# List all Helm releases and filter by name
releases=$(helm list --all-namespaces -q | grep "jlab-100g-nersc-ornl-job")

# Loop through each release and uninstall it
for release in $releases; 
do 
  helm uninstall $release --namespace default
done