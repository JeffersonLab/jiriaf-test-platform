#!/bin/bash

# test via template
for i in $(seq 1 25)
do
    i_padded=$(printf "%02d" $i)
    echo $i_padded
    helm template ersap$i ersap --set name=$i_padded
    sleep 5
done

# gradually increase the number of ersap instances every 5 seconds
for i in $(seq 1 25)
do
    i_padded=$(printf "%02d" $i)
    echo $i_padded
    helm install ersap$i ersap --set name=$i_padded
    # sleep 30
done



# gradually remove the number of ersap instances every 5 seconds
for i in $(seq 1 25)
do
    helm uninstall ersap$i
    # sleep 30
done



