#!/bin/bash

$(aws ecr get-login --no-include-email --region eu-west-2)
docker build -t node-app .
docker tag node-app:latest 733047563139.dkr.ecr.eu-west-2.amazonaws.com/node-app:latest
docker push 733047563139.dkr.ecr.eu-west-2.amazonaws.com/node-app:latest
