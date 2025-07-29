variable "aws_region" {
  description = "AWS region to deploy the resources"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for EC2 and EBS"
  type        = string
}

variable "volume_size" {
  description = "Size of the EBS volume"
  type        = number
}
