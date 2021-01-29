#!/bin/bash

set -o errexit -o pipefail -o nounset

docker build -t img_newspusher -f Dockerfile .

docker rm -f newspusher
docker run -d -p 8888:80 --restart always --name newspusher img_newspusher

echo "started testcontainer..."
echo
echo "Hints:"
echo "- open in browser                       -> http://localhost:8888/"
echo "- see logs                              -> docker logs newspusher"
echo "- open bash in running container        -> docker exec -ti newspusher bash"
echo "- stop container                        -> docker stop newspusher"
echo "- export image                          -> docker image save -o img_newspusher.tgz img_newspusher"
echo "- import image                          -> docker image load -i img_newspusher.tgz"
echo "- create and start container from image -> docker run -d -p 8888:80 --restart always --name newspusher img_newspusher"
