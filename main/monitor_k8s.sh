#!/bin/bash

commands=("kubectl get node" "kubectl get pods" "kubectl top node" "kubectl top pod")

for cmd in "${commands[@]}"; do
    gnome-terminal -- bash -c "watch -n 3 '$cmd'; exec bash"
done