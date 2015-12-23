#!/bin/bash
docker build -t board:app ./
docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
docker rm -f boardapp
docker run -i -t  --link=boardb:27017 -p 80:80 --name=boardapp board:app
