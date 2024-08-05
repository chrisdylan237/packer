# Specify the required Packer plugins
packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# Define the Amazon EBS source
source "amazon-ebs" "ubuntu" {
  region        = "us-east-2"
  source_ami    = "ami-003932de22c285676"
  instance_type = "t2.micro"
  ssh_username  = "ubuntu"
  ami_name      = "ACE-jenkins-ami-{{timestamp}}"
}

# Build block to specify the source and provisioners
build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "file" {
    source      = "jenkins.sh"
    destination = "/tmp/jenkins.sh"
  }

  provisioner "shell" {
    inline = ["chmod +x /tmp/jenkins.sh"]
  }

  provisioner "shell" {
    inline = ["sudo /tmp/jenkins.sh"]
  }
}
