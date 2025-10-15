#!/bin/bash


# Check if PAT token is provided
if [ -z "$PAT_TOKEN" ]; then
  echo "Error: PAT_TOKEN environment variable is not set."
  echo "Usage: export PAT_TOKEN=your_token"
  exit 1
fi

# Create base directory
sudo mkdir -p /opt/terraform


# Navigate to terraform directory
cd /opt/terraform

# Clone repository (remove old copy if exists)
if [ -d "/opt/terraform/tayarepo" ]; then
  echo "Removing existing tayarepo directory..."
  rm -rf /opt/terraform/tayarepo
fi

echo "Cloning repository..."
git clone https://"$PAT_TOKEN"@github.com/Tanishk-tech/tayarepo -b rootModules

# Go inside repo
cd /opt/terraform/tayarepo

# Initialize Terraform
echo "Running terraform init..."
terraform init

# Run terraform plan
echo "Running terraform plan..."
terraform plan 

#!/bin/bash

echo "Do you want to apply 'terraform apply'? (yes/no)"
read input

if [[ "$input" == "yes" || "$input" == "y" ]]; then
    echo "Running terraform apply..."
    terraform apply 
else
    echo "Okay, run terraform apply manually later."
fi

