# Disturbance Free Calling

**Minimising disturbances to enable productive remote work** - In today's remote work environment, unintentional interruptions can disrupt productivity and professional communication. This project tackles the challenge by creating a IoT-driven indicator designed to signal your availability and minimize disturbances during critical work activities like calls and meetings.

This is version 2.0 of the system, building on the foundations of the [original version](https://www.linkedin.com/feed/update/urn:li:activity:6930081862153342977) developed in 2020. The initial solution utilized an ESP32 microcontroller to poll the Webex API for status updates, displaying availability through an LED strip. While effective, areas for improvement were identified in terms of performance, reliability, and design. 

## Getting Started

### Prerequisites

Before getting started, ensure you have the following installed:
- [Node.js](https://nodejs.org/)
- [npm](https://www.npmjs.com/)
- [Terraform]()
- [AWS]()
- [Arduino]()

### Installation

Follow these steps to set up the project for your self:

1. **Clone the repository**:
```bash
git clone https://github.com/ImSeanConroy/disturbance-free-calling.git
cd disturbance-free-calling
```

1. Zip AWS Lambda Function.
```
cd Backend && npm run zip && cd ..
```

2. Configure Terraform Environment Variables.
```
export AWS_ACCESS_KEY_ID={Your AWS Access Key}
export AWS_SECRET_ACCESS_KEY={Your AWS Secret Access Key}
export AWS_REGION={Your AWS Region}
```

3. Configure AWS Infrastructure
```
terraform apply
```

4. Configure Device Secrets: Use the ouput from the following to configure `AWS_CERT_CA`, `AWS_CERT_CRT` and `AWS_CERT_PRIVATE` within the Firmware secret.
```
terraform output root_ca_url
terraform output device_certificate
terraform output device_private_key
```

5. Configure Device Credentials: Add Wifi SSID and Password to enable device to connenct with the interent

6. Upload to Device within Audrino IDE and test connection using the following command
```
```

1. Setup Webex Wekhook


## Features and Development Roadmap

This project is a work in progress, the following outlines the current features and planned improvements:

### Current Features
- **Custom PCB**: Designed specifically to support the IoT-driven indicator system.
- **Terraform Provisioning**: Automates the setup and deployment of necessary cloud infrastructure.
- **Webhook Integration**: Allows seamless communication between the IoT device and external services.

### Upcoming Features
- **Custom ESP32 Integration:** Incorporate the newly developed custom ESP32 board into the system architecture.

## Contributing

Contributions are welcome. Please open an issue or submit a pull request for any enhancements or bug fixes.

## License

This project is Distributed under the MIT License - see the [LICENSE](LICENSE) file for information.

## Support

If you are having problems, please let me know by [raising a new issue](https://github.com/ImSeanConroy/disturbance-free-calling/issues/new/choose).

## Acknowledgments

This project was made possible thanks to the following resources:

[AWS re:Post](https://repost.aws/questions/QUxlg-arOrTcaxFAdNEj7hqA/lambda-publish-a-mqtt-message-to-iot-core-inside-a-lambda-function-with-node-and-sdk-3) - Publish a MQTT Message to IOT Core inside a Lambda function with Node and SDK 3
[AWS Samples](https://github.com/aws-samples/aws-iot-esp32-arduino-examples) - Several Arduino examples for AWS IoT projects using ESP32.
