#!/bin/bash

ID=$1 #jlab-100g-nersc-ornl
INDEX=$2 #2
helm install $ID-job-fabric-$INDEX job/ --set Deployment.name=$ID-job-fabric-$INDEX --set Deployment.serviceMonitorLabel=$ID --set Deployment.ejfatNode=$INDEX