resource "aws_instance" "demo-server" {
  ami                    = "ami-007855ac798b5175e"
  instance_type          = "t2.medium"
  availability_zone      = "us-east-1a"
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  key_name               = "KeyPair"
  tags = {
    name = "kubernetes_instance"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install docker.io -y",
      "sudo systemctl enable docker.service",
      "sudo chown jenkins:jenkins /var/run/docker.sock",
      "sudo 644 /var/run/docker.sock",
      "sudo systemctl restart docker.service"
      "sudo wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64",
      "sudo chmod +x /home/ubuntu/minikube-linux-amd64",
      "sudo cp minikube-linux-amd64 /usr/local/bin/minikube",
      "curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl",
      "sudo chmod +x /home/ubuntu/kubectl",
      "sudo cp kubectl /usr/local/bin/kubectl",
      "sudo groupadd docker",
      "sudo usermod -aG docker ubuntu",
      "sudo systemctl restart docker.service"
    ]
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("KeyPair.pem")
    }
  }
}
