packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}
source "amazon-ebs" "amz3_gp3" {
  ami_name      = "backend-{{timestamp}}"
  instance_type = "t3.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name = "amzn2-ami-2023*"
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
