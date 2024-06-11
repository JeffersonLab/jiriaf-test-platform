#!/bin/bash

# run this on one of ejfat nodes.

image=gurjyan/ersap:v0.1

#input_volume=$((1024*))

docker run -it --rm --net=host -v /daqfs/java/clas_005038.1231.hipo:/clas_005038.1231.hipo \
    --entrypoint "/bin/bash" -e bufrate=$input_volume $image -c 'source ./setup; clasBlasterNTP -f /clas_005038.1231.hipo -file ./ejfat_uri'

# -bufrate=$bufrate to adjust volume