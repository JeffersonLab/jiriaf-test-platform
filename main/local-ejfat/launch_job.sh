#!/bin/bash

ID=jlab-100g-nersc-ornl
helm install $ID-job-ejfat-0 job/ --set Deployment.name=$ID-job-ejfat-0 --set Deployment.serviceMonitorLabel=$ID