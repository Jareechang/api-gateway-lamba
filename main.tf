provider "aws" {
  version = "~> 2.39.0"
  region  = "${var.aws_region}"
}

# Lambda

## Read the configuration from local files
locals {
    package_json = jsondecode(file("./package.json"))
    build_folder = "dist"
}

resource "aws_s3_bucket" "lambda" {
    bucket = "lambda-artifact-dev05"
    acl    = "private"
    tags = {
        Name        = "Dev"
        Environment = "Dev"
    }
}

resource "aws_s3_bucket_object" "lambda" {
    bucket = aws_s3_bucket.lambda.id
    key    = "main-${local.package_json.version}"
    source = "${local.build_folder}/main-${local.package_json.version}.zip"
}

resource "aws_lambda_function" "list_pets" {
    function_name = "${var.lambda_name}-${var.env}-list-pets"
    s3_bucket = "${aws_s3_bucket.lambda.id}"
    s3_key = "${aws_s3_bucket_object.lambda.id}"
    handler = "src/pet-list/index.handler"
    role = "${aws_iam_role.lambda_role.arn}"
    timeout = var.lambda_timeout 
    source_code_hash = "${filebase64sha256("dist/${aws_s3_bucket_object.lambda.id}.zip")}"
    runtime = "nodejs12.x"
    depends_on = [
        aws_cloudwatch_log_group.lambda_logs
    ]
}

resource "aws_lambda_function" "get_pet" {
    function_name = "${var.lambda_name}-${var.env}-get-pet"
    s3_bucket = "${aws_s3_bucket.lambda.id}"
    s3_key = "${aws_s3_bucket_object.lambda.id}"
    handler = "src/pet/index.handler"
    role = "${aws_iam_role.lambda_role.arn}"
    timeout = var.lambda_timeout 
    source_code_hash = "${filebase64sha256("dist/${aws_s3_bucket_object.lambda.id}.zip")}"
    runtime = "nodejs12.x"
    depends_on = [
        aws_cloudwatch_log_group.lambda_logs
    ]
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
    name = "/aws/lambda/${var.lambda_name}-${var.env}"
    retention_in_days = 14
}
