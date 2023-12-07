locals {
  api_id = split("/", var.api_gateway.data.infrastructure.arn)[2]
  split_role = split("/", module.lambda_application.identity)
  role_name  = element(local.split_role, length(local.split_role) - 1)
}

module "lambda_application" {
  source            = "github.com/massdriver-cloud/terraform-modules//massdriver-application-aws-lambda?ref=23a47fa"
  md_metadata       = var.md_metadata
  image             = var.runtime.image
  x_ray_enabled     = var.observability.x-ray.enabled
  retention_days    = var.observability.retention_days
  memory_size       = var.runtime.memory_size
  execution_timeout = var.runtime.execution_timeout
}


resource aws_iam_role_policy_attachment "attach_s3_read_policy" {
  role       = local.role_name
  policy_arn = var.s3_bucket.data.security.iam.read.policy_arn
}

resource aws_iam_role_policy_attachment "attach_s3_write_policy" {
  role       = local.role_name
  policy_arn = var.s3_bucket.data.security.iam.write.policy_arn
}

########

resource "aws_api_gateway_resource" "download" {
  rest_api_id = local.api_id
  parent_id   = var.api_gateway.data.infrastructure.root_resource_id
  path_part   = var.api.path_download
}

resource "aws_api_gateway_method" "download" {
  rest_api_id   = local.api_id
  resource_id   = aws_api_gateway_resource.download.id
  http_method   = var.api.http_method_download
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "download" {
  rest_api_id             = local.api_id
  resource_id             = aws_api_gateway_resource.download.id
  http_method             = aws_api_gateway_method.download.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.lambda_application.function_invoke_arn
}


resource "aws_api_gateway_resource" "upload" {
  rest_api_id = local.api_id
  parent_id   = var.api_gateway.data.infrastructure.root_resource_id
  path_part   = var.api.path_upload
}

resource "aws_api_gateway_method" "upload" {
  rest_api_id   = local.api_id
  resource_id   = aws_api_gateway_resource.upload.id
  http_method   = var.api.http_method_upload
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "upload" {
  rest_api_id             = local.api_id
  resource_id             = aws_api_gateway_resource.upload.id
  http_method             = aws_api_gateway_method.upload.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.lambda_application.function_invoke_arn
}

resource "aws_api_gateway_resource" "test" {
  rest_api_id = local.api_id
  parent_id   = var.api_gateway.data.infrastructure.root_resource_id
  path_part   = var.api.path_test
}

resource "aws_api_gateway_method" "test" {
  rest_api_id   = local.api_id
  resource_id   = aws_api_gateway_resource.test.id
  http_method   = var.api.http_method_test
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "test" {
  rest_api_id             = local.api_id
  resource_id             = aws_api_gateway_resource.test.id
  http_method             = aws_api_gateway_method.test.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.lambda_application.function_invoke_arn
}