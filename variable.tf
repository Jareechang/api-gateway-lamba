variable "aws_region" {
    default = "us-east-1"
}

variable "env" {
    default = "dev"
}

variable "accountId" {}

variable "lambda_name" {
    default = "api-gateway-function"
}

variable "lambda_timeout" {
    default = 120
}

