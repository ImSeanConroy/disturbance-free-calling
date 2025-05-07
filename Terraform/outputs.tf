# Device Certificate (Needed in Firmware)
output "device_certificate" {
  value       = aws_iot_certificate.certificate.certificate_pem
  description = "The Device Certificate (Device certificate needed in Firmware)"
  sensitive   = true
}

# Device Private Key (Needed in Firmware)
output "device_private_key" {
  value       = aws_iot_certificate.certificate.private_key
  description = "The Device Private Key (Key needed in Firmware)"
  sensitive   = true
}

# AWS Root CA URL (Needed in Firmware)
output "root_ca_url" {
  value       = "https://www.amazontrust.com/repository/AmazonRootCA1.pem"
  description = "URL to get AWS Root CA (AWS Root CA needed in Firmware)"
}
