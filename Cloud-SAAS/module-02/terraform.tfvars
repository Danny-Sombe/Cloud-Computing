# Add values
# Find the Ubuntu server 22.04 AMI for your region at this URL
# https://cloud-images.ubuntu.com/locator/ec2/
imageid                = "ami-0279a86684f669718"
# Use t2.micro for the AWS Free Tier
instance-type          = "t2.micro"
key-name               = "sonnlogix-key"
vpc_security_group_ids = "sg-0c38a5b78e9bb4b79"
tag-name               = "module-02"
raw-bucket             = "sonnlogix-raw-bucket"
finished-bucket        = "sonnlogix-finish-raw-bucket"
sns-topic              = "sonnlogix-sns-topic"
sqs                    = "sonnlogix-sqs"
dbname                 = "sonnlogixDBName"
uname                  = "controller"
pass                   = "wizard123!"
elb-name               = "logix-elb"
asg-name               = "sonnlogix-asg"
min                    = 2
max                    = 5
desired                = 3
tg-name                = "sonnlogix-tg"