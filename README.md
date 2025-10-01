# tayarepo 

# Download latest Packer (change version if needed)
wget https://releases.hashicorp.com/packer/1.11.2/packer_1.11.2_linux_amd64.zip

# Unzip
unzip packer_1.11.2_linux_amd64.zip

# Move to /usr/local/bin
sudo mv packer /usr/local/bin/

# Verify
packer --version


// packer init .
// packer build ui_ami.pkr.hcl
//sudo yum install packer -y  

# command for tar 
cd /opt/packer/tayarepo
tar czf nginx.tar.gz -C nginx .
tar czf javacode.tar.gz -C javacode .

