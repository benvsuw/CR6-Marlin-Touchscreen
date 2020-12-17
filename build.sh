#!/bin/bash

docker build -t cr6:latest --target=cr6-devel .

docker build -t cr6touch:latest --target=cr6touch-devel .

docker build -t cr6pkg:latest --target=cr6pkg .

[ -d installer ] && rm -rf installer
docker run --name=cr6pkginstaller cr6pkg:latest /bin/true
docker cp cr6pkginstaller:/installer .
docker container rm cr6pkginstaller
