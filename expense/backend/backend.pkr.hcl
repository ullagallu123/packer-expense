packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "amz2023" {
  ami_name      = "siva-backend-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "ap-south-1"
  source_ami = "ami-0fd05997b4dff7aac"
  ssh_username = "ec2-user"
}

build {
  name    = "backend"
  sources = ["source.amazon-ebs.amz2023"]

  provisioner "file" {
    source      = "backend.sh"
    destination = "/tmp/backend.sh"
  }

  provisioner "shell" {
    inline = [
      "chmod +x /tmp/backend.sh",
      "sudo /tmp/backend.sh"
      ]
  }
}
