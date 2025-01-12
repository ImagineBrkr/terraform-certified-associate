# MODULES

# Reusable pieces of configuration that can be called by multiple projects
module "vpc" {
  source = "terraform-aws-modules/vpc/aws" # This is in the public Terraform Registry
  version = "5.17.0"
  # We can use other sources:
  # source = "github.com/hashicorp/example" # Git
  # source = "git@github.com:hashicorp/example.git" # Git with SSH
  # source = "https://example.com/vpc-module.zip" # HTTP
  # source = "./vpc-modules" # Local

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

# Calling a local module
module "custom_ec2" {
    source = "./modules/ec2"

    instance_name = "my-ec2-instance"
    ami_id            = "ami-0c55b159cbfafe1f0"
    instance_type  = "t2.micro"
}

# Using the outputs of the module
output "custom_ec2_id" {
  value = module.custom_ec2.instance_id
}

# WORKSPACES

# We can use workspaces to have multiple environments
# Each environment will have its own tfstate file.

locals {
    instance_types_env = {
        "dev" = "t2.micro"
        "prod" = "m5.large"
        "default" = "t2.micro"
    }
}

resource "aws_instance" "instance_using_workspaces" {
  ami = "ami-0c55b159cbfafe1f0"
  # We can use the workspace to dynamically select some values
  instance_type = local.instance_types_env[terraform.workspace]
}
