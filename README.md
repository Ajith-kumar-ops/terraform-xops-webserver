# 🚀 Terraform XOps Web Server

This project uses **Terraform** to provision an AWS EC2 instance inside a custom **VPC** and **Subnet**, configures a **security group**, and runs an Apache web server that hosts a simple HTML page saying:

> **Hi this Ajith from XOps!**

---

## 🧰 Prerequisites

- Terraform installed (`terraform -v`)
- AWS CLI configured (`aws configure`)
- An existing AWS EC2 Key Pair (e.g., `xops-key.pem`)
- A GitHub account
