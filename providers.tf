# A provider is a plugin that lets Terraform manage an external API
# Terraform has a ton of providers
# The provider is downloaded when we run terraform init in .terraform
provider "aws" {
}
# Providers are not free of bugs, you can raise issues at Provider page.

# There are 3 primary types of provider tiers in Terraform
# Official: Owned and Mantained by HashiCorp (e.g. AWS)
# Partner: Owned and Mantained by Company with direct partnership with HashiCorp (e.g. Alibaba)
# Community: Owned and Mantained by Individual Contributors

# Namespaces, used to help users identify the organization responsible:
# Official: hashicorp (e.g. hashicorp/aws)
# Partner: Organization (e.g. mongodb/mongodbatlas)
# Community: Individual accounts (e.g. ImagineBrkr/example)

# Important:
# For non HashiCorp-mantained providers, terraform requires
# explicit source information

terraform {
  required_providers {
    digitalocean = {
        source = "digitalocean/digitalocean"
        # If we don't give a source, it will try to find hashicorp/digitalocean
    }
  }
}

provider "digitalocean" {}

# Resource blocks describes one or more infrastructure objects
# Resource blocks declares a resource type with a local name, both of them are the identifier
resource "aws_instance" "my_ec2_instance" {
 instance_type =  "t2.micro"
 ami = "ami-0664c8f94c2a2261b"
}

# You can use 'terraform destroy' to destroy ALL resources
# OR you can specify a target:
# terraform destroy -target "aws_instance.my_ec2_instance" -target "aws_instance.my_other_instance"

# Terraform stores the state of the infrastructure (creation, destroy, update, etc.)

