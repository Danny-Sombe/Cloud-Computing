# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a serverless image processing application built on AWS infrastructure for an ITMO 463 Module 05 assessment. Users upload images through a web interface, which are automatically converted to grayscale by an asynchronous backend worker, then the processed images are made available for download via email notifications.

## Architecture

**Three-tier system:**

1. **Frontend (Node.js/Express)** — `app.js`, `index.html`
   - Runs on EC2 instances behind an Application Load Balancer (ALB)
   - Handles file uploads to S3 raw bucket
   - Inserts user records into RDS MySQL database
   - Publishes jobs to SQS queue
   - Subscribes user email to SNS topic

2. **Backend Worker (Python)** — `app.py` (module-05-test.py is the autograder, not the worker)
   - Deployed on a dedicated EC2 instance (tagged `Type: backend`)
   - Triggered by systemd timer (`checkqueue.timer`) every 90 seconds
   - Polls SQS for pending jobs
   - Fetches raw image from S3, converts to grayscale using PIL
   - Uploads processed image to S3 finished bucket
   - Generates presigned URL and updates database
   - Publishes SNS notification with download link
   - Updates database to mark raw image as "done"

3. **Infrastructure (Terraform)** — `main.tf`, `variables.tf`, `terraform.tfvars`
   - Manages VPC, subnets, security groups, internet gateway, routing
   - Provisions RDS MySQL database from snapshot
   - Creates S3 buckets (raw and finished)
   - Sets up SQS queue, SNS topic, Secrets Manager
   - Creates IAM roles and instance profiles with permissions
   - Configures auto-scaling group with launch template

**Key AWS Services Used:**
- EC2 (ASG with ALB)
- RDS (MySQL)
- S3 (raw and finished image buckets)
- SQS (job queue)
- SNS (email notifications)
- Secrets Manager (username/password)
- IAM (roles and policies)

## Important Configuration

- **Region**: ap-southeast-2 (hardcoded in `app.js` and `app.py`)
- **Notification Email**: solutiontech954@gmail.com (hardcoded in `app.js:430`)
- **Terraform Variables**: Configured in `terraform.tfvars` — includes AMI ID, key name, S3 bucket names, security groups, etc.
- **Database**: Restored from snapshot; credentials stored in Secrets Manager (uname/pword)

## Common Development Tasks

### Infrastructure Management
```bash
# Validate Terraform configuration
terraform validate

# Plan infrastructure changes (review before applying)
terraform plan

# Apply infrastructure changes
terraform apply

# Destroy all infrastructure (careful!)
terraform destroy
```

### Testing
```bash
# Run the autograder (tests AWS infrastructure and application state)
python3 module-05-test.py
```

### Local Development/Debugging
- **Frontend app**: `node app.js` — requires AWS credentials and proper configuration
- **Backend worker**: `python3 app.py` — requires AWS credentials and environment setup
- **Service files**: `checkqueue.timer` and `checkqueue.service` define automated worker execution

## Code Notes

### Frontend (app.js)
- Uses AWS SDK v3 for S3, RDS, SQS, SNS, Secrets Manager, and RDS
- `listBuckets()` dynamically finds S3 bucket with "raw" in the name
- `insertRecord()` creates database entry with UUID as RecordNumber
- `sendMessageToQueue()` sends the record ID to SQS for processing
- `subscribeEmailToSNSTopic()` registers user email with SNS (executed on every upload)

### Backend (app.py)
- Fetches database credentials from Secrets Manager on startup
- Queries SQS for pending jobs (limited visibility timeout to 180 seconds)
- Uses mysql.connector to interact with RDS
- Parses S3 URLs using urllib to extract bucket and key
- PIL converts images to grayscale ("L" mode)
- Generates presigned URLs (2-hour expiration)
- Updates database records with finished URL and marks raw as "done"
- Unsubscribes email addresses from SNS after processing (cleanup)

### Autograder (module-05-test.py)
- Checks infrastructure state (VPC, subnets, security groups, etc.)
- Validates S3 buckets contain processed images (vegeta.jpg, knuth.jpg)
- Queries RDS via ELB `/db` endpoint (HTTP scraping with BeautifulSoup)
- Verifies SQS attributes (VisibilityTimeout=180, DelaySeconds=90)
- Confirms IAM policies and instance profiles are attached
- Scores the assessment (10 points total) and writes results to `module-05-results.txt`

## Deployment

**Frontend EC2 instances** (via ASG):
- Runs `install-env.sh` on launch
- Installs Node.js, nginx, PM2
- Clones repo from GitHub
- Starts `app.js` with PM2 (process manager)
- Nginx forwards port 80 to Node.js on port 3000

**Backend EC2 instance** (standalone):
- Runs `install-be-env.sh` on launch
- Installs Python3, pip, required libraries (PIL, boto3, mysql-connector)
- Copies `app.py` to `/usr/local/bin/`
- Registers `checkqueue.service` and `checkqueue.timer` with systemd
- Timer triggers service every 90 seconds

## Known Issues & Considerations

- **Email hardcoded**: Update `app.js:430` if changing SNS notification recipient
- **Region hardcoded**: Both app.js and app.py use "ap-southeast-2" — change if deploying elsewhere
- **SQL string concatenation**: `app.py` uses string concatenation for SQL (lines 184, 240) — vulnerable to injection but acceptable for this educational context
- **Image filenames**: Files must be unique; duplicates will overwrite
- **Secrets Manager cleanup**: Terraform creates secrets that are immediately deleted on destroy (`recovery_window_in_days = 0`)

## When to Check CLAUDE.md Again

- Making infrastructure changes (read main.tf and variables.tf sections)
- Modifying the upload flow or job processing (read Architecture and app.js/app.py sections)
- Changing AWS regions or credentials (check Configuration section)
