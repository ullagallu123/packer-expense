packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "amz2023" {
  ami_name      = "backend"
  instance_type = "t3.micro"
  region        = "us-east-1"
  source_ami = "ami-06c68f701d8090592"
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
