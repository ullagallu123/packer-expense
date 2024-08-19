packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "amz2023" {
  ami_name      = "frontend-{{isotime | clean_resource_name}}"
  instance_type = "t2.micro"
  region        = "ap-south-1"
  source_ami    = "ami-0a4408457f9a03be3"
  ssh_username  = "ec2-user"
}

build {
  name    = "frontend"
  sources = ["source.amazon-ebs.amz2023"]

  provisioner "file" {
    source      = "frontend.sh"
    destination = "/tmp/frontend.sh"
  }

  provisioner "shell" {
    inline = [
      "chmod +x /tmp/frontend.sh",
      "sudo /tmp/frontend.sh"
    ]
  }
}

