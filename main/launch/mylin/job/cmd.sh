#!/bin/bash

kubectl -n 100g apply -f /home/tsai/JIRIAF/JIRIAF-test-platform/main/job/configmap.yml
kubectl -n 100g apply -f /home/tsai/JIRIAF/JIRIAF-test-platform/main/job/pod.yml


kubectl -n 100g get pods

kubectl -n 100g delete pods

while true; do kubectl get node; echo ----; sleep 3; done


# for helm
helm install ersap1 `pwd` --set name=1