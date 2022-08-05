variable "access_key" {
  type    = string
  default = "access_key" 
}
variable "secret_key" {
  type    = string
  default = "secret_key" 
}
variable "region" {
  type    = string
  default = "aws_region" 
}
variable "tags" {
  type        = map(string)
  description = "mapping of tags to assign to the instance"
  default = {
    terraform = "true"
    Name      = "terraform-instance"
  }
}
# variable "key_name" {
#   type        = string
#   description = "ssh key to connect to instance"
#   default     = "ssh_key_name" 
# }
variable "ebs_root_size_in_gb" {
  type        = string
  description = "EBS size"
  default     = "10" 
}
variable "ami_id" {
  type        = string
  description = "os image id for the instance"
  default     = "ami_id" 
}
variable "subnet_id" {
  type        = string
  description = "subnet id to launch the instance in"
  default     = "subnet_id" 
}
variable "vpc_id" {
  type        = string
  description = "vpc"
  default     = "vpc_id" 
}
variable "availability_zone" {
  type        = string
  description = "az to start the instance in"
  default     = "availability_zone_id" 
}
variable "instance_count" {
  type        = number
  description = "instances count"
  default     = 1 
}