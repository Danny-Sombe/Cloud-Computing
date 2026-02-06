# Add values
# Find the Ubuntu server 22.04 AMI for your region at this URL
# https://cloud-images.ubuntu.com/locator/ec2/
# Custom AMI ID
imageid                = "ami-051e62c2b2b0f9f33"
# Use t2.micro for the AWS Free Tier
instance-type          = "t2.micro"
key-name               = "sonnlogix-key"
vpc_security_group_ids = "sg-0c38a5b78e9bb4b79"
cnt                    = 1
tag-name               = "module-04"
raw-s3                 = "sonnlogix-raw-bucket"
finished-s3            = "sonnlogix-finished-bucket"
user-sns-topic         = "sonnlogix-updates"
elb-name               = "sonnlogix-elb"
tg-name                = "sonnlogix-tg"
asg-name               = "sonnlogix-asg"
desired                = 3
min                    = 2
max                    = 5
number-of-azs          = 3
region                 = "ap-southeast-2"
raw-s3-bucket          = "sonnlogix-raw-s3-bucket"
finished-s3-bucket     = "sonnlogix-finished-s3-bucket"
dbname                 = "sonnlogixDBName"
snapshot_identifier    = "sonnlogix-snapshot"
sqs-name               = "sonnlogix-sqs"
username               = "controller"
