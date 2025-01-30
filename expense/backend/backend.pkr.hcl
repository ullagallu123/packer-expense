packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "amz3_gp3" {
  ami_name      = "backend-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "amzn3-ami-hvm-*-x86_64-gp3"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username  = "ec2-user"
}

build {
  name    = "backend"
  sources = ["source.amazon-ebs.amz3_gp3"]

  provisioner "file" {
    source      = "agent.sh"
    destination = "/tmp/agent.sh"
  }

  provisioner "shell" {
    inline = [
      "chmod +x /tmp/agent.sh",
      "sudo /tmp/agent.sh"
    ]
  }
}
