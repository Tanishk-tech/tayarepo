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

  # Upload app and NGINX configs
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
      # --- OS Update & Packages ---
      "sudo dnf -y update",
      "sudo dnf install -y nginx java-17-amazon-corretto java-17-amazon-corretto-devel cronie tar",

      # --- Enable NGINX ---
      "sudo systemctl daemon-reload",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",

      # --- Enable crond ---
      "sudo systemctl enable crond",
      "sudo systemctl start crond",

      # --- Extract uploaded archives ---
      "sudo mkdir -p /opt/javacode /opt/nginx",
      "sudo tar xzf /tmp/nginx.tar.gz -C /etc/nginx/",
      "sudo tar xzf /tmp/javacode.tar.gz -C /opt/javacode/",

      # --- Sample NGINX page ---
      "echo '<h1>UI AMI Ready (Amazon Linux 2023)</h1>' | sudo tee /usr/share/nginx/html/index.html",

      # --- Compile Java file ---
      "cd /opt/javacode",
      "sudo javac ex.java",

      # --- Create systemd service for Java Health Check ---
      "sudo bash -c 'cat > /etc/systemd/system/healthcheck.service <<EOF",
      "[Unit]",
      "Description=Simple Java Health Check Service",
      "After=network.target",
      "",
      "[Service]",
      "ExecStart=/usr/bin/java -cp /opt/javacode ex",
      "WorkingDirectory=/opt/javacode",
      "Restart=always",
      "User=ec2-user",
      "StandardOutput=append:/var/log/healthcheck.log",
      "StandardError=append:/var/log/healthcheck.log",
      "",
      "[Install]",
      "WantedBy=multi-user.target",
      "EOF'",

      # --- Enable and start the service ---
      "sudo systemctl daemon-reload",
      "sudo systemctl enable healthcheck",
      "sudo systemctl start healthcheck"
    ]
  }
}
