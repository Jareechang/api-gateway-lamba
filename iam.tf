
###################
# IAM - Lambda
###################

# Create lambda role to:
#
# - CW logs permissions

data "aws_iam_policy_document" "lambda_assume_role_policy" {
    version = "2012-10-17"
    statement {
        actions = [
            "sts:AssumeRole",
        ]

        principals {
            type = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }
    }
}

data "aws_iam_policy_document" "api_gateway_lambda" {
    version = "2012-10-17"

    statement {
        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
        effect = "Allow"
        resources = [
            "arn:aws:logs:*:*:*"
        ]
    }
}
 
resource "aws_iam_policy" "api_lambda_policy" {
    name = "api-lambda-dev-policy"
    policy = data.aws_iam_policy_document.api_gateway_lambda.json
}

resource "aws_iam_role" "lambda_role" {
    name               = "lambda-api-gateway-role"
    assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_policy_attachment" "attach_policy_to_role_lambda" {
    name       = "lambda-role-attachment"
    roles      = [aws_iam_role.lambda_role.name]
    policy_arn = aws_iam_policy.api_lambda_policy.arn
}

## Allow API gateway invoke
resource "aws_lambda_permission" "list_pet_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.list_pets.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "single_pet_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_pet.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}
    
