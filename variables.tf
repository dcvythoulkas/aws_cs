variable "aws_region" {
  description = "AWS region"
  type = string
  default = "eu-central-1"
}
variable "redrive_url" {
  description = "HTTP endpoint to consume messages"
  type = string
  default = "http://nohost.com/"
}
variable "aws_access_key" {
  description = "Administrative account key"
  type = string
  sensitive = true
}
variable "aws_secret_access_key" {
  description = "Administrative account secret key"
  type = string
  sensitive = true
}
