packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
    }
  }
}

variable "region" {
  default = "us-east-1"
}

source "amazon-ebs" "ui_ami" {
  region                  = var.region
  instance_type           = "t2.micro"
  ami_name                = "ui-ami-{{timestamp}}"

  source_ami_filter {
    filters = {
      name                = "al2023-ami-2023.*-x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["amazon"]
    most_recent = true
  }

  ssh_username = "ec2-user"
}

build {
  name    = "ui-ami-build"
  sources = ["source.amazon-ebs.ui_ami"]

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
      # Update OS
      "sudo dnf -y update",

      # Install required packages
      "sudo dnf install -y nginx java-17-amazon-corretto java-17-amazon-corretto-devel cronie tar",

      # Enable + start nginx
      "sudo systemctl daemon-reload",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",

      # Enable and start cron service (needed for @reboot jobs)
      "sudo systemctl enable crond",
      "sudo systemctl start crond",

      # Extract uploaded files
      "sudo mkdir -p /opt/javacode /opt/nginx",
      "sudo tar xzf /tmp/nginx.tar.gz -C /opt/nginx/",
      "sudo tar xzf /tmp/javacode.tar.gz -C /opt/javacode/",

      # Create sample landing page
      "echo '<h1>UI AMI Ready 🚀 (Amazon Linux 2023)</h1>' | sudo tee /usr/share/nginx/html/index.html",

      # Setup Java app to run at reboot
      "(crontab -l 2>/dev/null; echo '@reboot nohup java -cp /opt/javacode MainClass &') | crontab -"
    ]
  }
}
