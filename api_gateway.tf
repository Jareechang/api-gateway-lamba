resource "aws_api_gateway_rest_api" "api" {
    name        = "api"
}

resource "aws_api_gateway_resource" "api_resource" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    parent_id   = aws_api_gateway_rest_api.api.root_resource_id
    path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "get_method" {
    rest_api_id   = aws_api_gateway_rest_api.api.id
    resource_id   = aws_api_gateway_resource.api_resource.id
    http_method   = "ANY"
    authorization = "NONE"
}


resource "aws_api_gateway_integration" "integration" {
    rest_api_id             = aws_api_gateway_rest_api.api.id
    resource_id             = aws_api_gateway_resource.api_resource.id
    http_method             = aws_api_gateway_method.get_method.http_method
    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = aws_lambda_function.api_gateway_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "api_deployment" {
    depends_on = [
        aws_api_gateway_integration.integration,
    ]
    rest_api_id = aws_api_gateway_rest_api.api.id
    stage_name  = "stage" 
    lifecycle {
        create_before_destroy = true
    }
}

