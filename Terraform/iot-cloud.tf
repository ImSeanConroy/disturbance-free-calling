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

  tags = {
    project = "disturbance-free-calling"
  }
}

# IoT Certificate
resource "aws_iot_certificate" "certificate" {
  active = true
}

# Attach IoT Policy and IoT Certificate
resource "aws_iot_policy_attachment" "policy_certificate_attachment" {
  policy = aws_iot_policy.policy.name
  target = aws_iot_certificate.certificate.arn
}

# Attach IoT Thing and IoT Certificate
resource "aws_iot_thing_principal_attachment" "device_certificate_attachment" {
  principal = aws_iot_certificate.certificate.arn
  thing     = aws_iot_thing.device.name
}

# Device Certificate (Needed in Firmware)
output "device_certificate" {
  value = aws_iot_certificate.certificate.certificate_pem
  description = "The Device Certificate"
  sensitive = true
}

# Device Private Key (Needed in Firmware)
output "device_private_key" {
  value = aws_iot_certificate.certificate.private_key
  description = "The Device Private Key"
  sensitive = true
}

# AWS Root CA URL (Needed in Firmware)
output "root_ca_url" {
  value = "https://www.amazontrust.com/repository/AmazonRootCA1.pem"
  description = "URL to get AWS Root CA"
}