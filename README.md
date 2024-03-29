
# Terraform Infrastructure as Code Project

## Overview
This Terraform project aims to automate the provisioning of infrastructure on AWS using Infrastructure as Code (IaC) principles.

## Features
- Creates a VPC with public and private subnets
- Sets up an internet gateway for public internet access
- Configures route tables for routing traffic
- Deploys NAT gateways for private subnet internet access
- Launches EC2 instances with nginx installed for various purposes
- Utilizes security groups to control inbound and outbound traffic

## Usage
1. Clone this repository to your local machine:

    ```bash
    git clone https://github.com/Dappyplay4u/asys-terraform-project.git
    ```

2. Navigate to the project directory:

    ```bash
    cd asys-terraform-project
    ```

3. Make sure you have Terraform installed. If not, download it from [Terraform's official website](https://www.terraform.io/downloads.html) and follow the installation instructions.

4. Set up your AWS credentials by exporting them as environment variables or using AWS CLI configuration:

    ```bash
    export AWS_ACCESS_KEY_ID="your_access_key"
    export AWS_SECRET_ACCESS_KEY="your_secret_key"
    export AWS_DEFAULT_REGION="your_preferred_region"
    ```

5. Initialize the Terraform project:

    ```bash
    terraform init
    ```

6. Review and customize the `terraform.tfvars` file with your desired configurations.

7. Plan the infrastructure changes:

    ```bash
    terraform plan
    ```

8. Apply the changes to create the infrastructure:

    ```bash
    terraform apply
    ```

9. Confirm the changes by typing `yes` when prompted.

## Prerequisites
- AWS account
- Terraform installed
- Access key and secret key for AWS IAM user with appropriate permissions
