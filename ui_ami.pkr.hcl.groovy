// packer init .
// packer build ui_ami.pkr.hcl
//sudo yum install packer -y   

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
    owners      = ["137112412989"] # Amazon official Amazon Linux 2
    most_recent = true
  }
}

build {
  name    = "ui-ami"
  sources = ["source.amazon-ebs.ui"]

  # Copy local nginx config/files
  provisioner "file" {
    source      = "nginx/"
    destination = "/tmp/nginx"
  }

  # Copy local Java code
  provisioner "file" {
    source      = "javacode/"
    destination = "/tmp/javacode"
  }

  provisioner "shell" {
    inline = [
      # System update
      "sudo yum update -y",

      # Install nginx
      "sudo yum install -y nginx",
      "sudo systemctl enable nginx",

      # Test default page
      "echo '<h1>UI AMI Ready 🚀</h1>' | sudo tee /usr/share/nginx/html/index.html",

      # Install Java 11 (includes javac)
      "sudo amazon-linux-extras enable java-openjdk11",
      "sudo yum install -y java-11-openjdk java-11-openjdk-devel",

      # Setup directories
      "sudo mkdir -p /opt/javacode",

      # Copy files into place
      "sudo cp -r /tmp/nginx/* /etc/nginx/",
      "sudo cp -r /tmp/javacode/* /opt/javacode/",

      # Verification file
      "echo 'Java + Nginx AMI build complete' | sudo tee /opt/javacode/BUILD_INFO.txt",

      # Setup startup script for Java app
      "echo '@reboot nohup java -cp /opt/javacode Main > /opt/javacode/app.log 2>&1 &' | crontab -"
    ]
  }
}
