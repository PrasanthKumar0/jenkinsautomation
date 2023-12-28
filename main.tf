# Define AWS provider
provider "aws" {
  region = "ap-south-1"  # Specify your preferred AWS region
}

# Define Jenkins master instance
resource "null_resource" "jenkins_master" {
  # Use the existing Jenkins master public IP
  triggers = {
    instance_ip = "3.109.139.10"
  }

  # Provisioning script for Jenkins Master
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y openjdk-11-jre",
      "sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key",
      "echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install -y jenkins",
      "sudo systemctl status jenkins",
      "sudo systemctl enable jenkins",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = "3.109.139.10"  # Replace with the actual public IP address of your Jenkins master
      private_key = file("~/.ssh/id_rsa")
    }
  }
}

# Define Jenkins slave instance
resource "null_resource" "jenkins_slave" {
  # Use the existing Jenkins slave public IP
  triggers = {
    instance_ip = "65.0.55.128"
  }

  # Provisioning script for Jenkins Slave
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y openjdk-11-jre",
      "sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key",
      "echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install -y jenkins",
      "sudo systemctl status jenkins",
      "sudo systemctl enable jenkins",
      # Additional provisioning steps for Jenkins Slave if needed
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = "65.0.55.128"  # Replace with the actual public IP address of your Jenkins slave
      private_key = file("~/.ssh/id_rsa")
    }
  }
}

# Output the public IP addresses for easy access
output "jenkins_master_public_ip" {
  value = "3.109.139.10"  # Replace with the actual public IP address of your Jenkins master
}

output "jenkins_slave_public_ip" {
  value = "65.0.55.128"   # Replace with the actual public IP address of your Jenkins slave
}
