# Module 05 Assessment - Cloud Infrastructure & Application Project

## Project Overview

This project provides a complete cloud infrastructure and application deployment for Module 05. It provisions AWS resources using Terraform and deploys a Node.js/Express application with AWS service integrations including S3, RDS, SQS, SNS, and AWS Secrets Manager.

## Architecture

The infrastructure includes:

- **Networking**: Custom VPC with multi-AZ subnets, Internet Gateway, and route tables
- **Compute**: Auto Scaling Group with EC2 instances, Application Load Balancer, and backend instance
- **Storage**: S3 buckets for raw and processed data
- **Database**: RDS instance restored from snapshot
- **Messaging**: SQS queue for asynchronous processing and SNS topic for notifications
- **Security**: Security groups with HTTP (80), SSH (22), and MySQL (3306) access
- **Credentials**: AWS Secrets Manager for database username and password management
- **IAM**: Instance profiles and roles for accessing AWS services (S3, RDS, SNS, SQS, Secrets Manager)

## Directory Structure

```
M5-assessment-templates-and-code/
├── README.md                      # This file
├── main.tf                        # Primary Terraform configuration (VPC, compute, storage, database)
├── provider.tf                    # AWS provider configuration
├── variables.tf                   # Terraform variable definitions
├── terraform.tfvars               # Terraform variable values
├── app.js                         # Node.js/Express application
├── app.py                         # Python backend application
├── install-env.sh                 # Frontend environment setup script
├── install-be-env.sh              # Backend environment setup script
├── checkqueue.service             # Systemd service file
├── checkqueue.timer               # Systemd timer file
├── default                        # Nginx or reverse proxy configuration
├── index.html                     # Frontend HTML file
├── knuth.jpg                      # Image asset
└── vegeta.jpg                     # Image asset
```

## Prerequisites

### Local Machine Requirements
- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- Bash or shell environment for running scripts
- Node.js (if running app.js locally)
- Python (if running app.py locally)

### AWS Requirements
- AWS account with appropriate permissions
- EC2 key pair created in the target region
- RDS snapshot identifier available
- Required AWS service quotas for resources

## Setup & Deployment

### 1. Configure Variables

Edit `terraform.tfvars` with your specific values:

```hcl
imageid              = "ami-xxxxxxxxx"        # AMI ID for EC2 instances
instance-type        = "t3.micro"             # EC2 instance type
key-name             = "your-key-pair"       # EC2 key pair name
tag-name             = "coursera-project"    # Tag for resource identification
user-sns-topic       = "user-updates"        # SNS topic name
elb-name             = "coursera-elb"        # Load balancer name
tg-name              = "coursera-tg"         # Target group name
asg-name             = "coursera-asg"        # Auto Scaling Group name
region               = "ap-southeast-2"      # AWS region
number-of-azs        = 3                     # Number of availability zones
min                  = 1                     # ASG minimum instances
max                  = 3                     # ASG maximum instances
desired              = 2                     # ASG desired instances
raw-s3-bucket        = "coursera-raw-xxxxx"  # S3 bucket for raw data
finished-s3-bucket   = "coursera-fin-xxxxx"  # S3 bucket for finished data
dbname               = "coursera_db"         # Database name
snapshot_identifier  = "snap-xxxxxxxxx"      # RDS snapshot ID
sqs-name             = "coursera-queue"      # SQS queue name
username             = "admin"               # Database username
vpc_security_group_ids = []                  # Security group IDs (auto-managed)
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Review the Plan

```bash
terraform plan
```

### 4. Apply Configuration

```bash
terraform apply
```

Terraform will provision all resources. The output will include:
- Load Balancer DNS name (`url`)
- Database endpoint (`db-address`)
- Backend instance IP address (`backend-ip`)
- Target group ARN and ID

## Usage

### Accessing the Application

Once deployed, access the application through the Application Load Balancer DNS name:

```
http://<load-balancer-dns-name>
```

### Environment Setup

The Auto Scaling Group instances will automatically run `install-env.sh` on startup, which handles frontend dependencies and service installation.

The backend instance will run `install-be-env.sh` to set up Python dependencies and services.

### Scheduled Tasks

The `checkqueue.timer` and `checkqueue.service` files configure systemd to periodically check the SQS queue for messages.

## Key Features

- **Multi-AZ Deployment**: EC2 instances distributed across availability zones for high availability
- **Auto Scaling**: Automatically scales instances based on demand
- **Load Balancing**: Application Load Balancer distributes traffic across instances
- **Secrets Management**: Database credentials securely stored in AWS Secrets Manager
- **S3 Integration**: Buckets with public read access for data exchange
- **Asynchronous Processing**: SQS queue for background job processing
- **Database**: RDS instance with automatic credential injection from Secrets Manager
- **IAM Security**: Fine-grained roles and policies for service access

## Important Notes

### Security
- Security group allows HTTP (80), SSH (22), and MySQL (3306) from anywhere (0.0.0.0/0)
- For production, restrict these access rules to specific IP ranges
- Database password is randomly generated and managed by Secrets Manager
- S3 buckets are configured with public read access via bucket policies

### Costs
- Auto Scaling Group creates multiple EC2 instances
- RDS database instance charges apply
- S3 storage and data transfer costs apply
- Load Balancer incurs hourly charges
- Monitor AWS CloudWatch for resource utilization

### Database
- RDS instance is restored from a snapshot specified in variables
- Database credentials are automatically retrieved from Secrets Manager
- Initial database name and user must be consistent with snapshot

## Destroying Resources

To destroy all AWS resources and avoid unnecessary charges:

```bash
terraform destroy
```

This will delete:
- EC2 instances and Auto Scaling Group
- Load Balancer
- RDS database instance (if not protected)
- S3 buckets (configured with `force_destroy = true`)
- VPC and networking resources
- IAM roles and policies
- Secrets Manager secrets

## Testing

Run the included test file to verify the infrastructure:

```bash
python module-05-test.py
```

## Troubleshooting

### Instances not starting
- Check that the AMI ID exists in the specified region
- Verify EC2 instance quota is not exceeded
- Check IAM permissions for EC2 and other services

### Database connection issues
- Verify RDS snapshot exists
- Check security group allows MySQL (3306) traffic
- Confirm database subnet group is properly configured

### Load balancer shows unhealthy instances
- SSH into instance and check application logs
- Verify `install-env.sh` executed successfully
- Check application is listening on port 80

### S3 bucket name conflicts
- S3 bucket names must be globally unique
- Modify bucket names in `terraform.tfvars`

## References

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [AWS EC2 Auto Scaling](https://docs.aws.amazon.com/autoscaling/)
- [Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/)
- [RDS Database Instances](https://docs.aws.amazon.com/rds/)
- [AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/)

## Author
Created for Coursera Cloud Computing Course - Module 05 Assessment

---

*Last Updated: February 2026*
