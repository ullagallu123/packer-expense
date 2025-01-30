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
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = data.amazon-ami.latest_amz3_gp3.id
  ssh_username  = "ec2-user"

  source_ami_filter {
    filters = {
      name                = "amzn3-ami-hvm-*-x86_64-gp3"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  
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
