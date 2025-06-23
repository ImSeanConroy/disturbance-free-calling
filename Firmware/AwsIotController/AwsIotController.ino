/*
 * ============================================================
 * Project: Disturbance Free Calling
 * Developer: Sean Conroy
 * Board: Seeed Studio Xiao ESP32S3
 * License: MIT
 * Description:
 *   - Connects to AWS IoT Core using MQTT over a secure connection.
 *   - Subscribes to a predefined topic to receive real-time messages.
 *   - On receiving a message, the built-in LED blinks to signal incoming data.
 *   - Designed to enable quiet, non-intrusive notifications (e.g., for calls).
 *   - Uses WiFi credentials and certificates defined in "secrets.h".
 * ============================================================
 */

#include "secrets.h"
#include <WiFiClientSecure.h>
#include <MQTTClient.h>
#include <ArduinoJson.h>
#include "WiFi.h"

WiFiClientSecure net = WiFiClientSecure();
MQTTClient client = MQTTClient(256);

void connectAWS()
{
  // Connect to Wifi
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  Serial.print("Connecting to Wi-Fi");

  while (WiFi.status() != WL_CONNECTED){
    delay(500);
    Serial.print(".");
  }

  // Configure WiFiClientSecure to use the AWS IoT device credentials
  net.setCACert(AWS_CERT_CA);
  net.setCertificate(AWS_CERT_CRT);
  net.setPrivateKey(AWS_CERT_PRIVATE);

  // Connect to the MQTT broker on the AWS endpoint we defined earlier
  client.begin(AWS_IOT_ENDPOINT, 8883, net);

  // Create a message handler
  client.onMessage(messageHandler);

  Serial.println();
  Serial.print("Connecting to AWS IOT");

  while (!client.connect(THINGNAME)) {
    Serial.print(".");
    delay(100);
  }

  if(!client.connected()){
    Serial.println();
    Serial.print("AWS IoT Timeout.");
    return;
  }

  // Subscribe to a topic
  client.subscribe(AWS_IOT_SUBSCRIBE_TOPIC);
  Serial.println();
  Serial.print("AWS IoT Connected.");
}

void messageHandler(String &topic, String &payload) {
  Serial.println();
  Serial.println("Incoming: " + topic + " - " + payload);

  // Blink Built in LED
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);  
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
}

void setup() {
  Serial.begin(9600);
  pinMode(LED_BUILTIN, OUTPUT);
  connectAWS();
}

void loop() {
  client.loop();
  delay(1000);
}