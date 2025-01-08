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