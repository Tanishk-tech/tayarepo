packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_region" {
  default = "us-east-1"
}

variable "ami_name" {
  default = "ui-ami-${timestamp()}"
}

source "amazon-ebs" "ui" {
  region            = var.aws_region
  instance_type     = "t2.micro"
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-*-x86_64-gp2"
      virtualisation-type = "hvm"
      root-device-type    = "ebs"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username      = "ec2-user"
  ami_name          = var.ami_name
}

build {
  sources = ["source.amazon-ebs.ui"]

  provisioner "file" {
    source      = "/opt/packer/tayarepo/nginx.tar.gz"
    destination = "/tmp/nginx.tar.gz"
  }

  provisioner "file" {
    source      = "/opt/packer/tayarepo/javacode.tar.gz"
    destination = "/tmp/javacode.tar.gz"
  }

  provisioner "shell" {
    inline = [
      # Kill stale yum processes and remove locks
      "sudo killall -9 yum || true",
      "sudo rm -f /var/run/yum.pid /var/run/yum.lock || true",

      # Clean and update system
      "sudo yum clean all",
      "sudo yum update -y",

      # Enable Amazon Linux Extras for nginx
      "sudo amazon-linux-extras enable nginx1",
      "sudo yum install -y nginx",

      # Enable and start nginx service
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",

      # Extract uploaded tar files to desired locations
      "mkdir -p /opt/nginx",
      "tar -xzf /tmp/nginx.tar.gz -C /opt/nginx",
      "mkdir -p /opt/javacode",
      "tar -xzf /tmp/javacode.tar.gz -C /opt/javacode"
    ]
  }
}
