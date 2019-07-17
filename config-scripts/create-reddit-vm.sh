#!/usr/bin/env bash

gcloud compute instances create super-reddit-app --image-family reddit-full --machine-type=g1-small --tags puma-server --restart-on-failure --metadata-from-file startup-script=./packer/files/start.sh
