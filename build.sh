#!/bin/bash
set -e
set -x
curl -sSo src/tmp/install/functions.sh https://raw.githubusercontent.com/joernott/docker-oc-install-library/master/install_functions.sh
source src/tmp/install/functions.sh

patch_dockerfile DockerfileLTS
docker build -f DockerfileLTS -t registry.ott-consult.de/oc/tiki:18.3 .
docker tag registry.ott-consult.de/oc/tiki:18.3 registry.ott-consult.de/oc/tiki:lts
docker push registry.ott-consult.de/oc/tiki:18.3
docker push registry.ott-consult.de/oc/tiki:lts

patch_dockerfile Dockerfile19
docker build -f Dockerfile19 -t registry.ott-consult.de/oc/tiki:19.1 .
docker tag registry.ott-consult.de/oc/tiki:19.1 registry.ott-consult.de/oc/tiki:latest
docker push registry.ott-consult.de/oc/tiki:19.1
docker push registry.ott-consult.de/oc/tiki:latest
