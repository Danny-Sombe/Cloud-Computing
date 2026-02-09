# Add values
# Use the AMI of the custom Ec2 image you previously created
imageid                = "ami-051e62c2b2b0f9f33"
# Use t2.micro for the AWS Free Tier
instance-type          = "t2.micro"
key-name               = "sonnlogix-key"
vpc_security_group_ids = "sg-0c38a5b78e9bb4b79"
tag-name               = "module-05"
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
dbname                 = "company"
username               = "controller"
