provider "aws" {
  region = var.region
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = "bastion"
  public_key = tls_private_key.this.public_key_openssh
}

terraform {
  backend "s3" {
    bucket = "epam-terraform-state"
    key = "epam/terraform.tfstate"
    region = "us-east-2"
  }
}

module "vpc" {
  source = "github.com/Kristin0/terraform-modules/aws_network"
  instance_id = module.server.ec2_instance_id
}

module "database" {
  source = "github.com/Kristin0/terraform-modules/aws_database"
  subnet_ids = module.vpc.subnet_private_ids
  security_group_id = module.vpc.http_security_group_id

} 

module "server" {
  source = "github.com/Kristin0/terraform-modules/aws_server"
  security_group_id = module.vpc.http_security_group_id
  public_ip_ranges = module.vpc.public_ip_ranges
  subnet_public_ids = module.vpc.subnet_public_ids
  subnet_private_ids = module.vpc.subnet_private_ids
}

resource "null_resource" "command" {
  provisioner "local-exec" {
    command = "mv config ~/.ssh/"
  }

  depends_on = [
    module.server, 
    module.vpc,
    module.database,
    
  ]
} 


