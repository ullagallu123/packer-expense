packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "backend" {
  ami_name      = "backend"
  instance_type = "t3.micro"
  region        = "ap-south-1"
  source_ami = "ami-01376101673c89611"
  ssh_username = "ec2-user"
}

build {
    name = "my-first-build"
    sources = ["source.amazon-ebs.backend"]

    provisioner "shell" {
        inline = [
            
        ]
    }
}