#!/bin/bash



# gradually increase the number of ersap instances every 5 seconds
for i in $(seq 1 25)
do
    i_padded=$(printf "%02d" $i)
    echo $i_padded
    helm install ersap$i ersap --set name=ersap$i_padded
    sleep 30
done



# gradually remove the number of ersap instances every 5 seconds
for i in $(seq 1 25)
do
    i_padded=$(printf "%02d" $i)
    echo $i_padded
    helm uninstall ersap$i
    sleep 30
done




