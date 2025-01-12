terraform {
    # It is a good practice to add the required versions and providers
    required_version = "~> 1.9.0"

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

resource "aws_instance" "ec2_instance" {
    ami           = var.ami_id
    instance_type = var.instance_type

    tags = {
        Name = var.instance_name
    }
}

# We use variables to take inputs for the resource
variable "ami_id" {
    description = "The AMI ID to use for the instance"
    type        = string
}

variable "instance_type" {
    description = "The type of instance to start"
    type        = string
}

variable "instance_name" {
    description = "The name of the instance"
    type        = string
}

# For outputs of the module we use output
output "instance_id" {
  value = aws_instance.ec2_instance.id
}


# WORKSPACES

# We can use workspaces to have multiple environments
# Each environment will have its own tfstate file.

locals {
    instance_types_env = {
        "dev" = "t2.micro"
        "prod" = "t2.large"
        "default" = "t2.micro"
    }
}