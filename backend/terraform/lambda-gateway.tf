# IAM
resource "aws_iam_role" "iam_for_lambda_gateway_template" {
  name = "iam_for_lambda_gateway_template"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

# Lambda
resource "aws_lambda_function" "test_lambda" {
  filename      = "build.zip"
  function_name = "lambda-gateway-template"
  role          = aws_iam_role.iam_for_lambda_gateway_template.arn
  handler       = "handler.handle"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("build.zip")

  runtime = "nodejs12.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowMyDemoAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "lambda-gateway-template"
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.MyDemoAPI.execution_arn}/dev/*/lambda-gateway-template"
}


# Gateway
resource "aws_api_gateway_rest_api" "MyDemoAPI" {
  name        = "lambda-gateway-template"
  description = "This is my API template"
}

resource "aws_api_gateway_resource" "MyDemoResource" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  parent_id   = aws_api_gateway_rest_api.MyDemoAPI.root_resource_id
  path_part   = "lambda-gateway-template"
}

resource "aws_api_gateway_method" "MyDemoMethod" {
  rest_api_id   = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id   = aws_api_gateway_resource.MyDemoResource.id
  http_method   = "ANY"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "MyDemoIntegration" {
   rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
   resource_id = aws_api_gateway_resource.MyDemoResource.id
   http_method = aws_api_gateway_method.MyDemoMethod.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.test_lambda.invoke_arn
 }

resource "aws_api_gateway_deployment" "MyDemoDeployment" {
  depends_on = [aws_api_gateway_integration.MyDemoIntegration]

  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  stage_name  = "dev"

  variables = {
    "foo" = "bar"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_usage_plan" "MyUsagePlan" {
  name         = "lambda-gateway-template-UsagePlan"
  description  = "my lambda gateway usage plan"

  api_stages {
    api_id = "${aws_api_gateway_rest_api.MyDemoAPI.id}"
    stage  = "${aws_api_gateway_deployment.MyDemoDeployment.stage_name}"
  }
}

resource "aws_api_gateway_api_key" "Key" {
  name = "lambda-gateway-template-key"
  value = var.api_key
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = "${aws_api_gateway_api_key.Key.id}"
  key_type      = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.MyUsagePlan.id}"
}
