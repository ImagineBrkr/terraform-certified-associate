# MULTI PROVIDER

# If we use alias, we can use multiple provider configurations
provider "aws" {
  alias = "north_america_aws"
  region = "us-east-1"
}

provider "aws" {
  alias = "europe_aws"
  region = "eu-central-1"
}

resource "aws_security_group" "sg_na" {
    name = "NA SG"
    provider = aws.north_america_aws
}

resource "aws_security_group" "sg_eu" {
  name = "EU SG"
    provider = aws.europe_aws
}

# SENSITIVE VALUES

# We can use sensitive on variables/outputs to hide them on cli or logs

variable "secret_var" {
    type = string
    sensitive = true
}
# It will still appear on the state file.