#!/bin/bash

echo "=== Installing Packer ==="
cd /tmp
wget -q https://releases.hashicorp.com/packer/1.11.2/packer_1.11.2_linux_amd64.zip
unzip -o packer_1.11.2_linux_amd64.zip
sudo mv -f packer /usr/local/bin/
packer --version

echo "=== Preparing Packer workspace ==="
mkdir -p /opt/packer
cd /opt/packer

if [ -z "${PAT_TOKEN:-}" ]; then
  echo "Error: PAT_TOKEN is not set."
  exit 1
fi

git clone https://"$PAT_TOKEN"@github.com/Tanishk-tech/tayarepo -b ami
cd /opt/packer/tayarepo

echo "make terraform script executable..."
chmod +x terraform_run.sh

echo "=== Creating archives for nginx and javacode ==="
tar czf nginx.tar.gz -C nginx .
tar czf javacode.tar.gz -C javacode .

echo "=== Initializing and building Packer template ==="
packer init .
packer build ui_ami.pkr.hcl

echo "=== Creating S3 bucket ==="
aws s3api create-bucket \
    --bucket dev-taya-aehsc-tf-state \
    --region us-east-1

echo "=== Script Completed Successfully ==="
