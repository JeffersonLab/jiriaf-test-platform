#!/bin/bash

kubectl -n 100g apply -f /home/tsai/JIRIAF/JIRIAF-test-platform/main/job/configmap.yml
kubectl -n 100g apply -f /home/tsai/JIRIAF/JIRIAF-test-platform/main/job/pod.yml


kubectl -n 100g get pods

kubectl -n 100g delete pods