terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {}

# AWS Account ID
data "aws_caller_identity" "current" {}

# IoT Thing
resource "aws_iot_thing" "device" {
  name = "DisturbanceFreeCallingDevice"
  attributes = {
    Project = "Disturbance-Free-Calling"
    Model = "Development-ESP32"
  }
}

# IoT Policy
resource "aws_iot_policy" "policy" {
  name = "DisturbanceFreeCallingPolicy"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "iot:Connect",
        "Resource": "arn:aws:iot::${data.aws_caller_identity.current.account_id}:client/DisturbanceFreeCallingDevice"
      },
      {
        "Effect": "Allow",
        "Action": "iot:Subscribe",
        "Resource": "arn:aws:iot::${data.aws_caller_identity.current.account_id}:topicfilter/disturbance-free-calling/sub"
      },
      {
        "Effect": "Allow",
        "Action": "iot:Receive",
        "Resource": "arn:aws:iot::${data.aws_caller_identity.current.account_id}:topic/disturbance-free-calling/sub"
      }
    ]
  })
}

# IoT Certificate
resource "aws_iot_certificate" "certificate" {
  active = true
}

# Attach IoT Policy and IoT Certificate
resource "aws_iot_policy_attachment" "example" {
  policy = aws_iot_policy.policy.name
  target = aws_iot_certificate.certificate.arn
}

# Attach IoT Thing and IoT Certificate
resource "aws_iot_thing_principal_attachment" "att" {
  principal = aws_iot_certificate.certificate.arn
  thing     = aws_iot_thing.device.name
}

# Device Certificate (Needed in Firmware)
output "device_certificate" {
  sensitive = true
  value = aws_iot_certificate.certificate.certificate_pem
}

# Device Private Key (Needed in Firmware)
output "device_private_key" {
  sensitive = true
  value = aws_iot_certificate.certificate.private_key
}

# AWS Root CA URL (Needed in Firmware)
output "root_ca_url" {
  value = "https://www.amazontrust.com/repository/AmazonRootCA1.pem"
}