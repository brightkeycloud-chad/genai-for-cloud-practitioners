terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "llm-foundation-demo"
}

# IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Project = var.project_name
    Purpose = "LLM Foundation Model Demo"
  }
}

# IAM policy for Bedrock access
resource "aws_iam_role_policy" "lambda_bedrock_policy" {
  name = "${var.project_name}-bedrock-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel"
        ]
        Resource = "arn:aws:bedrock:${var.aws_region}::foundation-model/anthropic.claude-3-haiku-20240307-v1:0"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${var.aws_region}:*:*"
      }
    ]
  })
}

# Lambda function
resource "aws_lambda_function" "chat_function" {
  filename      = "chat_function.zip"
  function_name = "${var.project_name}-chat"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  architectures = ["arm64"]
  timeout       = 30

  depends_on = [aws_iam_role_policy.lambda_bedrock_policy]

  tags = {
    Project = var.project_name
    Purpose = "Chat interface for Foundation Model demo"
  }
}

# API Gateway
resource "aws_api_gateway_rest_api" "chat_api" {
  name = "${var.project_name}-api"

  tags = {
    Project = var.project_name
  }
}

resource "aws_api_gateway_resource" "chat_resource" {
  rest_api_id = aws_api_gateway_rest_api.chat_api.id
  parent_id   = aws_api_gateway_rest_api.chat_api.root_resource_id
  path_part   = "chat"
}

resource "aws_api_gateway_method" "chat_method" {
  rest_api_id   = aws_api_gateway_rest_api.chat_api.id
  resource_id   = aws_api_gateway_resource.chat_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "chat_integration" {
  rest_api_id = aws_api_gateway_rest_api.chat_api.id
  resource_id = aws_api_gateway_resource.chat_resource.id
  http_method = aws_api_gateway_method.chat_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.chat_function.invoke_arn
}

resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.chat_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.chat_api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "chat_deployment" {
  depends_on = [aws_api_gateway_integration.chat_integration]

  rest_api_id = aws_api_gateway_rest_api.chat_api.id
}

resource "aws_api_gateway_stage" "chat_stage" {
  deployment_id = aws_api_gateway_deployment.chat_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.chat_api.id
  stage_name    = "prod"
}

output "api_endpoint" {
  description = "API Gateway endpoint URL"
  value       = "https://${aws_api_gateway_rest_api.chat_api.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.chat_stage.stage_name}/chat"
}
