packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "amz2023" {
  ami_name      = "frontend"
  instance_type = "t3.micro"
  region        = "us-east-1"
  source_ami = "ami-06c68f701d8090592"
  ssh_username = "ec2-user"
}

build {
  name    = frontend"
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
