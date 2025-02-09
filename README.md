# Disturbance Free Calling

**Minimising disturbances to enable productive remote work** - In today's remote work environment, unintentional interruptions can disrupt productivity and professional communication. This project tackles the challenge by creating a IoT-driven indicator designed to signal your availability and minimize disturbances during critical work activities like calls and meetings.

This is version 2.0 of the system, building on the foundations of the [original version](https://www.linkedin.com/feed/update/urn:li:activity:6930081862153342977) developed in 2020. The initial solution utilized an ESP32 microcontroller to poll the Webex API for status updates, displaying availability through an LED strip. While effective, areas for improvement were identified in terms of performance, reliability, and design. 

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

[AWS Samples](https://github.com/aws-samples/aws-iot-esp32-arduino-examples) - Several Arduino examples for AWS IoT projects using ESP32.
