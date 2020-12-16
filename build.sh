#!/bin/bash

docker build -t cr6:latest --target=cr6-devel .

docker build -t cr6touch:latest --target=cr6touch-devel .
