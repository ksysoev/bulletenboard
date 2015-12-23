#!/bin/bash
docker build --tag board/db ./
docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
docker rm -f boardb
docker run --name boardb -p 27017:27017  -d board/db
