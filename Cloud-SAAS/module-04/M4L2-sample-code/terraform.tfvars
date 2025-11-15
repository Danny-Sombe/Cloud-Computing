# Add values
# Find the Ubuntu server 22.04 AMI for your region at this URL
# https://cloud-images.ubuntu.com/locator/ec2/
imageid                = "ami-0279a86684f669718"
# Use t2.micro for the AWS Free Tier
instance-type          = "t2.micro"
key-name               = "sonnlogix-key"
vpc_security_group_ids = "sg-0c38a5b78e9bb4b79"
cnt                    = 1
tag-name               = "module-04"
