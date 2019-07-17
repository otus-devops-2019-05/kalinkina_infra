#!/usr/bin/env bash

cd /home/lada
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
