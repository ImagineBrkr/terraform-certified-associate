resource "aws_eip" "my_eip" {
    domain = "vpc"
}

resource "aws_security_group" "allow_tls" {
    name = "firewall"
}

resource "aws_vpc_security_group_ingress_rule" "allow_eip" {
    # There is a dependency here, so this resource will be created after all the resources referenced
    security_group_id = aws_security_group.allow_tls.id # We can reference other resource attributes
    cidr_ipv4 = "${aws_eip.my_eip.public_ip}/32" # Or insert them within a string
    from_port = var.http_port # See variables
    to_port = var.http_port
    ip_protocol = "tcp"
}

# With outputs we can show the attributes of the resources on the CLI
output "my_eip" {
  value = aws_eip.my_eip.public_ip
}

# We can use variables to use an alias for repeated values
# Or to provide values from outside the files like this:
# terraform plan -var="http_port=80"
variable "http_port" {
  default = "80"
  description = "HTTP Port"
}
# We can create *.tfvars files to give values to the variables, see port.tfvars
# To use a specific var file, use "terraform apply -var-file"port.tfvars""
# Files named terraform.tvars or *.auto.tfvars are automatically loaded
# Or we can use Environment Variables that start with "TF_VAR"
# "export TF_VAR_http_port=80"
# The priority is like this: 
# -var or -var-file on cli > *.auto.tfvars (in lexical order) > terraform.tfvars.json > terraform.tfvars > ENV Variables
# For -var or -var-file, the latest counts
# If there is no definition nowhere, you will need to manually type it on the cli

# DATA TYPES

# string = "Hello123"
# number = 123
# bool = true
# list = ["test-1", "test-2"]
# set = ["test-1", "test-2"] (like list but without ordering)
# map = {name = "Juan", age = 52}
# null

# Retrieving a value from a map or list:

variable "test_map" {
  default = {
    us-east-1 = "ami-123456"
    us-east-2 = "ami-654321"
  }
  type = map
}

variable "test_list" {
  default = ["us-east-1", "us-east-2"]
  type = list
}

resource "aws_instance" "test_instance" {
  instance_type = var.test_list[0]
  ami = var.test_map["us-east-1"]
}

# COUNT ARGUMENT

# With count we can create multiple resources with the same configuration
resource "aws_security_group" "multiple_security_groups" {
  count = 2
  name = "firewall-${count.index}"
}

# We can access the resources with aws_security_group.multiple_security_groups[0] and so on

# CONDITIONAL EXPRESSIONS

# We can use conditional expressions to create resources based on a condition
variable "Environment" {
  default = "dev"
}

resource "aws_instance" "conditional_instance" {
  instance_type = var.Environment == "dev" ? "t2.micro" : "t2.large" # If the condition is true, the first value is used, otherwise the second
  ami = "ami-123456"
}

# We can use more complex conditionals with "&&" and "||" operators

# FUNCTIONS

# We can use functions to manipulate data like:
# max(1,2) -> 2
# file("file.txt") -> Reads the file
# min(1,2) -> 1
# Full docs: https://developer.hashicorp.com/terraform/language/functions
# Terraform does NOT support user defined functions

# LOCAL VALUES

# We can use local values to store intermediate values
# The difference with variables is that local values are not exposed to the outside

locals {
  common_tags = {
    Name = "test"
    Environment = var.Environment
    CreadionDate = formatdate("YYYY-MM-DD", timestamp()) # We can use functions
  }
}

resource "aws_instance" "local_instance" {
  instance_type = "t2.micro"
  ami = "ami-123456"
  tags = local.common_tags
}

resource "aws_security_group" "local_security_group" {
  tags = local.common_tags
  name = "firewall-local"
}

# DATA SOURCES

# Data sources are used to retrieve information from the provider

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity
data "aws_caller_identity" "current" {
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id # We can get data from AWS
}

# For filtering, we need to look at the docs

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
data "aws_ami" "latest" {
  most_recent = true # We can filter by most recent
  owners = ["amazon"] # We can filter by owner
  filter {
    name = "name" # We can filter by name
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
  }
  filter {
    name = "region"
    values = ["us-east-1"]
  }
}

output "ami_id" {
  value = data.aws_ami.latest.id
}

# LOGGING

# For detailed logs, use the TF_LOG environment variable
# Levels: TRACE, DEBUG, INFO, WARN, ERROR
# To save the logs, use TF_LOG_PATH environment variable