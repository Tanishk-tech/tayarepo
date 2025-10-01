packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
    }
  }
}

source "amazon-ebs" "ui" {
  region        = "us-east-1"
  instance_type = "t2.micro"
  ssh_username  = "ec2-user"
  ami_name      = "ui-ami-{{timestamp}}"

  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-*-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["137112412989"]  # Amazon Linux 2 official
    most_recent = true
  }
}

build {
  name    = "ui-ami"
  sources = ["source.amazon-ebs.ui"]

  ############################
  # Upload tarballs from local machine
  ############################
  provisioner "file" {
    source      = "/opt/packer/tayarepo/nginx.tar.gz"
    destination = "/tmp/nginx.tar.gz"
  }

  provisioner "file" {
    source      = "/opt/packer/tayarepo/javacode.tar.gz"
    destination = "/tmp/javacode.tar.gz"
  }

  ############################
  # Shell provisioning
  ############################
  provisioner "shell" {
    inline = [
      # Kill any existing yum process & remove stale locks
      "sudo killall -9 yum || true",
      "sudo rm -f /var/run/yum.pid /var/run/yum.lock || true",

      # Update system and install packages
      "sudo yum update -y",
      "sudo yum install -y nginx",
      "sudo amazon-linux-extras enable java-openjdk11",
      "sudo yum install -y java-11-openjdk java-11-openjdk-devel",

      # Extract nginx tarball
      "sudo mkdir -p /etc/nginx",
      "sudo tar xzf /tmp/nginx.tar.gz -C /etc/nginx",

      # Extract Java code
      "sudo mkdir -p /opt/javacode",
      "sudo tar xzf /tmp/javacode.tar.gz -C /opt/javacode",

      # Compile Java file
      "cd /opt/javacode && sudo javac ex.java || true",

      # Setup cron job to run Java at reboot
      "echo '@reboot nohup java -cp /opt/javacode ex > /opt/javacode/app.log 2>&1 &' | crontab -",

      # Enable nginx service
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]
  }
}
