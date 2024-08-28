#!/bin/bash

ID=jlab-100g-nersc-ornl
INDEX=2
helm install $ID-job-ejfat-$INDEX job/ --set Deployment.name=$ID-job-ejfat-$INDEX --set Deployment.serviceMonitorLabel=$ID