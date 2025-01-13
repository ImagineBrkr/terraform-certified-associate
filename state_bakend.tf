# We can use backends to save our terraform.state files
# This way every machine that works on the same project
# Will have a centralized state file

terraform {
  # For access we can use the same credentials we use for our resources creation
  # It needs the necessary permissions
  backend "s3" {
    bucket = "254718126515-my-aws-bucket"
    key    = "terraform/state"
    region = "us-east-1"
    # dynamodb_table = "my-lock-table" #S3 doesn't support lock by default
    # We can use a dynamodb table for this
  }
  # Terraform automatically locks the state file when doing write operations
  # Some backends don't support this so check the documentation
}

# We can access outputs from other remote states to get vales using a data source
data "terraform_remote_state" "remote_state" {
  backend = "s3"
  config = {
    bucket = "254718126515-my-aws-bucket-2"
    key    = "terraform/state"
    region = "us-east-1"
  }
}

output "remote_item" {
  value = data.terraform_remote_state.remote_state.outputs.private_ip
}

# IMPORT

# We can use import to import manually created resources to our terraform configuration.
# This will save it in the tf files and in the state.

import {
  to = aws_security_group.manually_created_group # Terraform resource that will be created
  id = "sg-1234"                                 # Id of the manually created group
}