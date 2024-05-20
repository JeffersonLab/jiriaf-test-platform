#!/bin/bash

for i in $(seq 1 40)
do
    i_padded=$(printf "%02d" $i)
    for prefix in 100 200 300 400
    do
        port=$prefix$i_padded
        nc -z localhost $port &> /dev/null
        if [ $? -ne 0 ]; then
            echo "SSH tunnel on port $port is not open"
        fi
    done
done