/**************** S3 ********************/
output "aws_cloudfront_origin_access_identity_strapi" {
  value = aws_cloudfront_origin_access_identity.strapi
}

output "aws_cloudfront_origin_access_identity_nextjs" {
  value = aws_cloudfront_origin_access_identity.nextjs
}

output "s3_bucket_strapi" {
  value = aws_s3_bucket.strapi
}

output "s3_bucket_nextjs" {
  value = aws_s3_bucket.nextjs
}

output "s3_bucket_logging" {
  value = aws_s3_bucket.logging
}

/**************** API Gateway ********************/
output "api_gateway_id" {
  value = aws_api_gateway_rest_api.main.id
}

/*output "api_gateway_key" {
  value = aws_api_gateway_api_key.api-key
} */

output "aws_api_gateway_usage_plan" {
  value = aws_api_gateway_usage_plan.api-usage-plan
}

/**************** Lambda ********************/
output "lambda_proxy_handler" {
  value = aws_lambda_function.backend-ecs
}

output "lambda_cf_request" {
  value = aws_lambda_function.cdn-request
}

output "lambda_cf_response" {
  value = aws_lambda_function.cdn-response
}

/**************** SQS ********************/
output "aws_sqs_queue1" {
  value = aws_sqs_queue.queue1
}

/**************** Ec2 ********************/
output "aws_alb_target_group" {
  value = aws_alb_target_group.strapi-tg
}

output "strapi-alb-security-group" {
  value = aws_security_group.strapi-alb-security-group
}

output "aws_lb" {
  value = aws_lb.strapi-ec2
}

output "aws_autoscaling_group" {
  value = aws_autoscaling_group.strapi
}
