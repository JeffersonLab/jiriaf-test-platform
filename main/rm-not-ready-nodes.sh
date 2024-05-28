#!/bin/bash

# Get all nodes
nodes=$(kubectl get nodes --no-headers | awk '{print $1}')

for node in $nodes; do
  # Check if the node is not ready
  if ! kubectl get node "$node" | grep -q " Ready"; then
    # Drain the node
    kubectl drain "$node" --ignore-daemonsets --delete-local-data --force
    # Delete the node
    kubectl delete node "$node"
  fi
done