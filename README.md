# Disturbance Free Calling

**Minimising disturbances to enable productive remote work** - In today's remote work environment, unintentional interruptions can disrupt productivity and professional communication. This project aims to solves this challenge by creating an IoT-driven indicator that signals your availability and minimizes disturbances during critical work activities such as calls and meetings.

This is **version 2.0**, building on the foundations of the [original version](https://www.linkedin.com/feed/update/urn:li:activity:6930081862153342977) developed in 2020. The initial solution utilized an **ESP32 microcontroller based development board** to poll the **Webex API** and display availability using an **LED strip**. While effective, improvements were needed in **performance, reliability, and design** — which are now addressed in this upgraded version.. 

## Table of Contents

- [Features and Development Roadmap](#features-and-development-roadmap)
- [Architecture Diagram](#architecture-diagram)
- [Hardware Requirements](#hardware-requirements)
- [Getting Started](#getting-started)
- [Contributing](#contributing)
- [License](#license)
- [Support](#support)
- [Acknowledgments](#acknowledgments)

## Features and Development Roadmap

This project is a work in progress, the following outlines the current features and planned improvements:

### Current Features

- **Terraform Provisioning**: Automates the setup and deployment of necessary cloud infrastructure.
- **Webhook Integration**: Allows seamless communication between the IoT device and external services.

### Upcoming Features

- **Custom PCB**: Designed specifically to support the IoT-driven indicator system.
- **Custom ESP32 Integration:** Incorporate the newly developed custom ESP32 board into the system architecture.

## Architecture Diagram

Below is a high-level overview of how the architecture operates:

![Architecure Diagram](https://github.com/ImSeanConroy/disturbance-free-calling/blob/main/.github/architecture-diagram.png)

**1. Webhook Trigger** - A Webex webhook sends a request to an AWS API Gateway endpoint when a user’s availability status changes.

**2. Cloud Processing** - AWS API Gateway triggers an AWS Lambda function, which processes the Webex data and publishes the updated availability status to an AWS IoT Core MQTT topic.

**3. Device Update** - The device subscribes to the AWS IoT topic and receives status updates, updatings the LED indicator accordingly.
 
**Note**: A simplified polling-based version of the firmware is also available for setups that cannot use Webex webhooks. This version periodically queries the Webex API for status updates instead of relying on real-time push notifications.

## Hardware Requirements

To build this system, you’ll need the following components:

- Seeed XIAO ESP32C3 - [PiHut](https://thepihut.com/products/seeed-xiao-esp32c3?variant=53975115661697)
- LED Strip - [PiHut](https://thepihut.com/products/flexible-rgb-led-strip-neopixel-ws2812-sk6812-compatible-144-led-meter)
- Power Adapter - [PiHut](https://thepihut.com/products/usb-a-to-usb-c-cable-1m?variant=42520360779971)
- 3D Printed Enclosure (Requires 3D Printer)

## Getting Started

### Prerequisites

Before getting started, ensure you have the following installed:

- [Node.js](https://nodejs.org/en/download/)
- [npm](https://www.npmjs.com/)
- [Terraform](https://developer.hashicorp.com/terraform/install)
- [AWS](https://aws.amazon.com/free/)
- [Arduino](https://www.arduino.cc/)

### Installation

Follow these steps to set up the project for your self:

1. **Clone the repository**:
```bash
git clone https://github.com/ImSeanConroy/disturbance-free-calling.git
cd disturbance-free-calling
```

2. **Zip AWS Lambda Function.**
```bash
cd Backend && npm run zip && cd ..
```

3. **Configure Terraform Environment Variables.**
```bash
export AWS_ACCESS_KEY_ID={Your AWS Access Key}
export AWS_SECRET_ACCESS_KEY={Your AWS Secret Access Key}
export AWS_REGION={Your AWS Region}
```

4. **Configure AWS Infrastructure using Terraform**
```bash
terraform apply
```

5. **Configure Device Secrets**: Configure `AWS_CERT_CA`, `AWS_CERT_CRT` and `AWS_CERT_PRIVATE` in the Firmware secrets file with the ouput from the following:
```bash
terraform output root_ca_url
terraform output device_certificate
terraform output device_private_key
```

6. **Configure Device Credentials**: Add Wifi SSID and Password to enable device to connenct with the interent.

7. **Upload to Device Firmware**: Within Audrino IDE and test connection.

8. **Configure Webex Webhook**: Ensure the Webex webhook is configured for to send requests to your AWS API Gateway.

## Contributing

Contributions are welcome. Please open an issue or submit a pull request for any enhancements or bug fixes.

## License

This project is Distributed under the MIT License - see the [LICENSE](LICENSE) file for information.

## Support

If you are having problems, please let me know by [raising a new issue](https://github.com/ImSeanConroy/disturbance-free-calling/issues/new/choose).

## Acknowledgments

This project was made possible thanks to the following resources:

- [AWS re:Post](https://repost.aws/questions/QUxlg-arOrTcaxFAdNEj7hqA/lambda-publish-a-mqtt-message-to-iot-core-inside-a-lambda-function-with-node-and-sdk-3) - Publish a MQTT Message to IOT Core inside a Lambda function with Node and SDK 3
- [AWS Samples](https://github.com/aws-samples/aws-iot-esp32-arduino-examples) - Several Arduino examples for AWS IoT projects using ESP32.
