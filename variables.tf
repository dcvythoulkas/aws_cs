variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}
variable "ssh_key_name" {
  description = "Key name for SSH key"
  type        = string
  default     = "osuser"
}
variable "ssh_public_key" {
  description = "SSH RSA key"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDhneFC8a9R87Uq1JAqD4T2CENZ6VThuxcKbz0JxNmCZvsB0+GGVqLqUAEXXprUes7ab2QCbHq/PooIgo1uE12GEwfele78291xnTuR/dAIetNsoRSYAxnrVMlnBLc3f5XfVbeZ01YpVUxxShDNiRskZlxWwELrO9qgITTiwdg7izby5POdPkMNvEpdA8acuBT03vhKTPmO2o0uqc5+mbIinCXYe9copvRn5SmfeQzyWsLz8OAh5KJ+czNIHo8UXievaxo3oph/28/MOS8NMB9Jls4m9wSQs21p6DbIze2pq36U5yVW/pldu0+IBpG34sCy46guA3IocciCDvvXo8W9"
}

variable "redrive_url" {
  description = "HTTP endpoint to consume messages"
  type        = string
  default     = "http://nohost.com/"
}
variable "aws_access_key" {
  description = "Administrative account key"
  type        = string
  sensitive   = true
}
variable "aws_secret_access_key" {
  description = "Administrative account secret key"
  type        = string
  sensitive   = true
}
