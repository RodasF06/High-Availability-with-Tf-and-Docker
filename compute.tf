data "aws_ami" "ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "private_instance" {
  ami                    = data.aws_ami.ecs_optimized.id 
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_subnet_a.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
#!/bin/bash
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

echo "=== Iniciando Docker ==="
systemctl enable docker
systemctl start docker

echo "=== Instalando AWS CLI v2 ==="
cd /tmp

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

yum install -y unzip

unzip awscliv2.zip

./aws/install

echo "=== Verificando AWS CLI ==="
aws --version

echo "=== Login en ECR ==="
aws ecr get-login-password --region us-east-1 | \
docker login --username AWS --password-stdin 945596537419.dkr.ecr.us-east-1.amazonaws.com

echo "=== Descargando imagen ==="
docker pull 945596537419.dkr.ecr.us-east-1.amazonaws.com/mi-app-repo:latest

echo "=== Ejecutando contenedor ==="
docker run -d \
-p 80:80 \
--restart always \
--name mi-app \
945596537419.dkr.ecr.us-east-1.amazonaws.com/mi-app-repo:latest

echo "=== Contenedores activos ==="
docker ps

EOF
  tags = {
    Name = "App-Server-Private"
  }
}