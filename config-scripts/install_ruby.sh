#!/usr/bin/env bash

sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential
ruby -v
bundler -v
