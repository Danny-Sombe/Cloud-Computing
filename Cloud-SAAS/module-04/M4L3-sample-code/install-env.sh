#!/bin/bash

# Install dependecies here:
##############################################################################
# Install Node JS
# https://github.com/nodesource/distributions#installation-instructions-deb
##############################################################################
sudo apt update
curl -fsSL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt install -y nodejs
node -v
##############################################################################
# Use NPM (node package manager to install AWS JavaScript SDK)
##############################################################################
# Run NPM to install the NPM Node packages needed for the code
# You will start this NodeJS script by executing the command: node app.js
# from the directory where app.js is located. The program `pm2` can be
# used to auto start NodeJS applications (as they don't have a normal
# systemd service handler).
# <https://pm2.keymetrics.io/docs/usage/quick-start/>. This will require
# the install of PM2 via npm as well.
cd /home/ubuntu
sudo -u ubuntu npm install @aws-sdk/client-s3 @aws-sdk/client-sns @aws-sdk/client-rds @aws-sdk/client-secrets-manager express
