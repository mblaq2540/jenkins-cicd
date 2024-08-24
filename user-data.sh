#!/bin/bash
sudo yum update -y

sudo yum install git -y

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

sudo dnf update
sudo dnf install java-17-amazon-corretto -y
sudo dnf install java-17-amazon-corretto-devel -y

sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io-2023.key
sudo dnf upgrade
sudo dnf install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins

sudo yum install -y yum-utils shadow-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform


sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user

cd /opt
sudo wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz
sudo tar -xvzf apache-maven-3.9.9-bin.tar.gz
sudo mv apache-maven-3.9.9 maven