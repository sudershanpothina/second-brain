provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
}


resource "aws_sns_topic" "topic-us-east" {
  provider = aws.us-east-1 // point to the provider of choice
  name     = "topic-us-east"
}

resource "aws_sns_topic" "topic-us-west" {
  provider = aws.us-west-2
  name     = "topic-us-west"
}

verbose logging enable
export TF_LOG=TRACE
diable
export TF_LOG= 


conditional provider based on workspace

// selects east-1 when the value is default and west 2 when its anything else
provider "aws" {
  region = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
}