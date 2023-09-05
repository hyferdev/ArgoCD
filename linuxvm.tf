# Creates an AWS Linux VM
resource "aws_instance" "argo_instance" {
  ami = var.ami
  subnet_id = aws_subnet.argo_subnet.id  
  associate_public_ip_address = true  
  instance_type = var.instance_type
  key_name = var.keys
  vpc_security_group_ids = [aws_security_group.argo_sg.id]
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update
    sudo yum install wget
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install  -o root -g root -m 0755 minikube-linux-amd64 /usr/local/bin/minikube
    sudo rm -f /minikube-linux-amd64
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    sudo rm -f /kubectl
    sudo yum install docker -y
    sudo systemctl enable --now docker
    sudo useradd k8svc
    sudo usermod -aG docker k8svc && newgrp docker
    su k8svc -c 'minikube start'  
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    sudo rm -f get_helm.sh
    helm repo add argo https://argoproj.github.io/argo-helm
    helm repo update
    sudo yum install yum-utils -y
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
    sudo yum install terraform -y
    git clone https://github.com/hyferdev/ArgoTerra.git
    sudo terraform -chdir=/ArgoTerra init
    su k8svc -c 'terraform -chdir=/ArgoTerra apply -auto-approve -lock=false'   
    EOF
  user_data_replace_on_change = true
  tags = {
    Name = "Argo_EC2"
  }
}
