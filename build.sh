#!/bin/bash
set -e
set -x
curl -sSo src/tmp/install/functions.sh https://raw.githubusercontent.com/joernott/docker-oc-install-library/master/install_functions.sh
source src/tmp/install/functions.sh

patch_dockerfile DockerfileLTS
docker build -f DockerfileLTS -t registry.ott-consult.de/oc/tiki:15.4 .
docker tag registry.ott-consult.de/oc/tiki:15.4 registry.ott-consult.de/oc/tiki:lts
docker push registry.ott-consult.de/oc/tiki:15.4
docker push registry.ott-consult.de/oc/tiki:lts

patch_dockerfile Dockerfile17
docker build -f Dockerfile17 -t registry.ott-consult.de/oc/tiki:17.0 .
docker tag registry.ott-consult.de/oc/tiki:17.0 registry.ott-consult.de/oc/tiki:latest
docker push registry.ott-consult.de/oc/tiki:17.0
docker push registry.ott-consult.de/oc/tiki:latest
