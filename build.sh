#!/bin/bash

set -o errexit -o pipefail -o nounset

docker build -t img_newspusher -f Dockerfile .

docker rm -f newspusher
docker run -d -p 8888:80 --restart always --name newspusher img_newspusher
