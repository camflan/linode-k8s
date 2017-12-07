#!/bin/bash

apt-get update

sudo apt-get install -yq \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update

sudo apt-get install -yq docker-ce=17.03.2~ce-0~ubuntu-xenial

#sudo ip link set docker0 down
#sudo ip link delete docker0
