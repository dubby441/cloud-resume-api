# 🌐 Cloud Resume Project

This is a personal cloud engineering project inspired to test my knowledge. It showcases a simple FastAPI backend hosted on an EC2 instance with automated deployment using GitHub Actions and infrastructure provisioned with Terraform.

## 🚀 Project Features

- ✅ A FastAPI backend containerized with Docker
- ✅ Deployment to AWS EC2 using Terraform
- ✅ Automated provisioning with `user_data`
- ✅ Static Elastic IP for persistent public access
- ✅ CI/CD pipeline via GitHub Actions
- ✅ Docker Compose support for production setup
- ✅ GitHub Secrets for secure deployments


## 🧰 Tech Stack

- **Backend**: FastAPI (Python)
- **Infrastructure as Code**: Terraform
- **Cloud**: AWS EC2 (with VPC, Subnet, Security Group)
- **CI/CD**: GitHub Actions
- **Containerization**: Docker + Docker Compose

## ⚙️ GitHub Secrets Required
- `EC2_HOST`: Public IP or EIP of your EC2 instance
- `EC2_SSH_KEY`: Your private SSH key (base64 encoded)
- `DOCKER_HUB_USERNAME` and `DOCKER_HUB_PASSWORD` (if using private repo)

## 📝 Notes
- `user_data` is used instead of Terraform `remote-exec` for better reliability.
- Docker Compose handles container lifecycle on EC2.
- Any Docker Hub image can be used in `docker-compose.yml`.
