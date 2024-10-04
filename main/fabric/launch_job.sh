#!/bin/bash

ID=jlab-100g-nersc-ornl
INDEX=$1 #2
# change values.yaml to use port 21001, 31001, 41001, 11001, 51001 before running this script
helm install $ID-job-fabric-$INDEX job/ --set Deployment.name=$ID-job-fabric-$INDEX --set Deployment.serviceMonitorLabel=$ID --set Deployment.ejfatNode=$INDEX