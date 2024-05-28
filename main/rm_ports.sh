#!/bin/bash

for i in $(seq 2 7)
do
    for port in 10000 20000 30000 40000
    do
        pid=$(lsof -ti tcp:$((port+i)))
        if [ -n "$pid" ]; then
            kill -9 $pid
            echo "Killed process $pid on port $((port+i))"
        fi
    done
done