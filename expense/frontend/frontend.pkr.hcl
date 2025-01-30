packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

source "amazon-ebs" "amz3_gp3" {
  ami_name      = "backend-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = data.aws_ami.amazon_linux.id
  ssh_username  = "ec2-user"
  
  block_device_mappings = [
    {
      device_name = "/dev/sda1"
      ebs = {
        volume_size = 8
        volume_type = "gp3"
      }
    }
  ]
}

build {
  name    = "backend"
  sources = ["source.amazon-ebs.amz3_gp3"]

  provisioner "file" {
    source      = ".sh"
    destination = "/tmp/backend.sh"
  }

  provisioner "shell" {
    inline = [
      "chmod +x /tmp/backend.sh",
      "sudo /tmp/backend.sh"
    ]
  }
}
