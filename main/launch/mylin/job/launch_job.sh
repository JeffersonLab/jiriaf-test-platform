#!/bin/bash



# gradually increase the number of ersap instances every 5 seconds
for i in $(seq 1 25); do helm install ersap$i `pwd` --set name=$i; sleep 30; done



# gradually remove the number of ersap instances every 5 seconds
for i in $(seq 1 25); do helm uninstall ersap$i; sleep 30; done




