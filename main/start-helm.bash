#!/bin/bash

ID=$1
helm install $ID-prom /home/tsai/JIRIAF/JIRIAF-test-platform/main/job/prom --set Deployment.name=$ID
helm install $ID-job /home/tsai/JIRIAF/JIRIAF-test-platform/main/job/ersap-helm/job --set Deployment.name=$ID-job --set Deployment.serviceMonitorLabel=$ID