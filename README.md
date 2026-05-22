# Arquitectura de Alta Disponibilidad Web en AWS utilizando Terraform y Docker

## Descripción del Proyecto

Este repositorio fue creado con el propósito de simular un escenario real de infraestructura cloud.

En este caso, una Fintech necesita exponer una aplicación web manteniendo alta disponibilidad, validación automática del estado de las instancias, reducción del downtime causado por errores humanos y salida segura a internet para descargar imágenes Docker desde Amazon ECR.

---

## Tecnologías Utilizadas

* AWS
* Terraform
* Docker
* Application Load Balancer (ALB)
* Target Groups
* NAT Gateway
* Amazon ECR
* Amazon EC2
* Health Checks

---

## Arquitectura

El diagrama de arquitectura se encuentra en:

"Diagram.png"
---

## Características Principales

* Arquitectura Multi-AZ
* EC2 privadas
* Balanceador de carga público
* Health checks automáticos
* Descarga segura de imágenes Docker desde ECR
* Infraestructura como código (IaC) utilizando Terraform
* Contenedores Docker desplegados automáticamente mediante user_data

---

## Lecciones Aprendidas

Durante este proyecto trabajé principalmente en:

* Troubleshooting de Docker
* ECS Optimized AMI vs ECS Service
* ALB Health Checks
* Debugging de user_data
* Networking entre subnets privadas y NAT Gateway
* Integración entre EC2, Docker y ECR

---

## Mejoras Futuras

* Auto Scaling Group
* HTTPS utilizando ACM
* Route53
* CloudWatch Monitoring
* ECS Fargate
* CI/CD automatizado
