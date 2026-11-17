output "rest_api_id" {
  description = "Identyfikator REST API."
  value       = aws_api_gateway_rest_api.this.id
}

output "stage_name" {
  description = "Nazwa stage."
  value       = aws_api_gateway_stage.this.stage_name
}

output "invoke_url" {
  description = "Adres stage zwracany przez API Gateway."
  value       = aws_api_gateway_stage.this.invoke_url
}

output "execution_arn" {
  description = "ARN wywołań stage. Do powiązania z WAF służy ARN stage."
  value       = aws_api_gateway_stage.this.execution_arn
}

output "web_acl_arn" {
  description = "ARN web ACL podpiętego do stage."
  value       = aws_wafv2_web_acl.this.arn
}

output "domain_name" {
  description = "Własna domena bramy. Null, gdy nie ustawiono."
  value       = one(aws_api_gateway_domain_name.this[*].domain_name)
}
