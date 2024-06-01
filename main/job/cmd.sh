#!/bin/bash

kubectl -n 100g apply -f /home/tsai/JIRIAF/JIRIAF-test-platform/main/job/configmap.yml
kubectl -n 100g apply -f /home/tsai/JIRIAF/JIRIAF-test-platform/main/job/pod.yml


kubectl -n 100g get pods

kubectl -n 100g delete pods

while true; do kubectl get node; echo ----; kubectl get pods -n 100g; echo ===; sleep 3; done

watch -n 3 "(kubectl get node; echo; kubectl get pods; echo; kubectl top node; echo; kubectl top pod)"

# for helm
helm install ersap1 `pwd` --set name=1

# install 25 ersap instances
for i in $(seq 1 25); do helm install ersap$i `pwd` --set name=$i; 

# remove 25 ersap instances
for i in $(seq 1 25); do helm uninstall ersap$i; done