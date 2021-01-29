#!/bin/bash

set -o errexit -o pipefail -o nounset

docker build -t img_newspusher -f Dockerfile .

docker rm -f newspusher
docker run -d -p 8888:80 --restart always --name newspusher img_newspusher

echo "open                           -> http://localhost:8888/"
echo "see logs                       -> docker logs newspusher"
echo "open bash in running container -> docker exec -ti newspusher bash"
echo "stop container                 -> docker stop newspusher"
