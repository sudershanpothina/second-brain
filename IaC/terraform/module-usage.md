modules
    main.tf
    variables.tf
    outputs.tf
main.tf
    use module using path

main.tf - modules/vpc
```
provider "aws" {
    region = var.region
}
resource "aws_vpc" "this" {
    cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "this" {
    vpc_id = aws_vpc.this.id
    cidr_block = "10.0.0.1/24"
}
data "aws_ssm_parameter" "this" {
    name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}
```
variables.tf
```
variable "region" {
  type    = string
  default = "us-east-1"
}
```
outputs.tf
```
output "subnet_id" {
    value = aws_subnet.this.id
}
output "ami_id" {
    value = data.aws_ssm_parameter.this.value
}
```

main.tf

```
variable "main_region" {
    type = string
    default = "us-east-1"
}
provider "aws" {
    region = var.main_region
}
module "vpc" {
    source = "./modules/vpc"
    region = var.main_region
}
resource "aws_instance" "my-instance" {
    ami = module.vpc.ami_id
    subnet_id = module.vpc.subnet_id
    instance_type = "t2.micro"
}
output "privateip" {
    value = aws_instance.my-instance.private_ip
}
```