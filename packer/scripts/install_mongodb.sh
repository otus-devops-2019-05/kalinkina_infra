#!/usr/bin/env bash
set -e
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv D68FA50FEA312927
bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
apt-get update
apt-get install -y mongodb-org
systemctl enable mongod
