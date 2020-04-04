resource "aws_eip" "api-gateway-eip" {
  instance = module.api-gateway.instance-id
}

module "api-gateway" {
  source = "./node-server"

  ami-id               = "ami-0e01ce4ee18447327"
  iam-instance-profile = module.api-gateway-codedeploy.iam-instance-profile
  key-pair             = aws_key_pair.microservice.key_name
  name                 = "api-gateways"
  subnet-id            = aws_subnet.microservice-subnet-public.id
  vpc-security-group-ids = [
    aws_security_group.allow-http.id,
    aws_security_group.allow-ssh.id,
    aws_security_group.allow-all-outbound.id
  ]
}

module "api-gateway-codedeploy" {
  source = "./codedeploy-app"

  app-name          = "api-gateways"
  ec2-instance-name = module.api-gateway.name
}
