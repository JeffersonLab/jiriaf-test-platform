#!/bin/bash

docker run -v $(pwd):/prom -it --rm python:3.7 bash -c "pip install pyyaml && python /prom/create_prom_config.py"