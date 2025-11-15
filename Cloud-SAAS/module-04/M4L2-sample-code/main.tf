# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "helloworld" {
  ami                    = var.imageid
  instance_type          = var.instance-type
  key_name               = var.key-name
  vpc_security_group_ids = [var.vpc_security_group_ids]

  tags = {
    Name = var.tag-name
  }
}
