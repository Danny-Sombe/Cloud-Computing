#!/bin/bash

# Install Backend dependecies here:

##############################################################################
# Installing Python Pip and library Dependencies
##############################################################################
sudo apt update -y
sudo apt install -y python3-dev python3-setuptools python3-pip python3-venv npm

# Create virtual environment for Python packages
sudo python3 -m venv /opt/app-env
sudo /opt/app-env/bin/pip install --upgrade pip
sudo /opt/app-env/bin/pip install pillow
sudo /opt/app-env/bin/pip install boto3
sudo /opt/app-env/bin/pip install mysql-connector-python
cd /home/ubuntu

# Command to clone your private repo via SSH usign the Private key
####################################################################
# Note - change "hajek.git" to be your private repo name (hawk ID) #
####################################################################
if [ -d "/home/ubuntu/Cloud-Computing/.git" ]; then
	sudo -u ubuntu git -C /home/ubuntu/Cloud-Computing pull --ff-only
else
	sudo -u ubuntu git clone https://github.com/Danny-Sombe/Cloud-Computing.git
fi

# Start the nodejs app where it is located via PM2
# https://pm2.keymetrics.io/docs/usage/quick-start
cd /home/ubuntu/Cloud-Computing/Cloud-SAAS/module-05/Final-Projects/M5-assessment-templates-and-code
sudo -u ubuntu npm install uuid

echo "Copying ./app.py to /usr/local/bin/..." 
sudo cp ./app.py /usr/local/bin/
echo "Copying ./checkqueue.timer to /etc/systemd/system/..."
sudo cp ./checkqueue.timer /etc/systemd/system/
echo "Copying ./checkqueue.service to /etc/systemd/system/..."
sudo cp ./checkqueue.service /etc/systemd/system/

sudo systemctl enable --now checkqueue.timer
sudo systemctl enable checkqueue.service
