resource "aws_api_gateway_rest_api" "api" {
    name        = "api"
}

resource "aws_api_gateway_resource" "list" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    parent_id   = aws_api_gateway_rest_api.api.root_resource_id
    path_part   = "pets"
}

resource "aws_api_gateway_method" "list" {
    rest_api_id   = aws_api_gateway_rest_api.api.id
    resource_id   = aws_api_gateway_resource.list.id
    http_method   = "GET"
    authorization = "NONE"
}


resource "aws_api_gateway_integration" "list" {
    rest_api_id             = aws_api_gateway_rest_api.api.id
    resource_id             = aws_api_gateway_resource.list.id
    http_method             = aws_api_gateway_method.list.http_method
    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = aws_lambda_function.list_pets.invoke_arn
}

resource "aws_api_gateway_resource" "single" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    parent_id   = aws_api_gateway_resource.list.id
    path_part   = "{petId}"
}

resource "aws_api_gateway_method" "single" {
    rest_api_id   = aws_api_gateway_rest_api.api.id
    resource_id   = aws_api_gateway_resource.single.id
    http_method   = "GET"
    authorization = "NONE"

    request_parameters = {
        "method.request.path.petId" = true
    }
}


resource "aws_api_gateway_integration" "single" {
    rest_api_id             = aws_api_gateway_rest_api.api.id
    resource_id             = aws_api_gateway_resource.single.id
    http_method             = aws_api_gateway_method.single.http_method
    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = aws_lambda_function.get_pet.invoke_arn
}

resource "aws_api_gateway_deployment" "api_deployment" {
    depends_on = [
        aws_api_gateway_integration.list,
        aws_api_gateway_integration.single,
    ]
    rest_api_id = aws_api_gateway_rest_api.api.id
    stage_name  = "stage" 
    lifecycle {
        create_before_destroy = true
    }
}

