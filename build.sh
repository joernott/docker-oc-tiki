#!/bin/bash
set -e

docker build -f DockerfileLTS -t registry.ott-consult.de/oc/tiki:15.4 .
docker tag registry.ott-consult.de/oc/tiki:15.4 registry.ott-consult.de/oc/tiki:lts
docker build -f Dockerfile17 -t registry.ott-consult.de/oc/tiki:17.0 .
docker tag registry.ott-consult.de/oc/tiki:17.0 registry.ott-consult.de/oc/tiki:latest
docker push registry.ott-consult.de/oc/tiki:15.4
docker push registry.ott-consult.de/oc/tiki:lts
docker push registry.ott-consult.de/oc/tiki:17.0
docker push registry.ott-consult.de/oc/tiki:latest
