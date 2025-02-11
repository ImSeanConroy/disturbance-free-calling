#include "secrets.h"

#include <ArduinoJson.h>
#include <WiFi.h>
#include <HTTPClient.h>

const char* WEBEX_ENDPOINT = "https://webexapis.com/v1/people/";
int polling_rate = 30000;

void connectToWiFi() {
  Serial.print("Connecting to Wi-Fi");
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nConnected to Wi-Fi!");
}

String fetchWebexStatus() {
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("Wi-Fi not connected!");
    return "";
  }

  HTTPClient http;
  String fullUrl = String(WEBEX_ENDPOINT) + WEBEX_USER_ID;
  
  Serial.println("Requesting: " + fullUrl);
  http.begin(fullUrl);
  http.addHeader("Authorization", "Bearer " + String(WEBEX_API_KEY));
  http.addHeader("Content-Type", "application/json");

  int httpResponseCode = http.GET();
  String response = "";

  if (httpResponseCode > 0) {
    response = http.getString();
    Serial.println("Response: " + response);
  } else {
    Serial.print("HTTP Request failed, Code: ");
    Serial.println(httpResponseCode);
  }

  http.end();
  return response;
}

void setLEDState(const char* status) {
  if (strcmp(status, "call") == 0 || 
      strcmp(status, "meeting") == 0 || 
      strcmp(status, "presenting") == 0 || 
      strcmp(status, "DoNotDisturb") == 0) {
    digitalWrite(LED_BUILTIN, HIGH);
  } else {
    digitalWrite(LED_BUILTIN, LOW);
  }
}

void setup() {
  Serial.begin(9600);
  pinMode(LED_BUILTIN, OUTPUT);
  connectToWiFi();
}

void loop() {
  String response = fetchWebexStatus();
  if (!response.isEmpty()) {
    StaticJsonDocument<200> doc;
    DeserializationError error = deserializeJson(doc, response);

    if (!error) {
      const char* status = doc["status"];
      Serial.print("Status: ");
      Serial.println(status);
      setLEDState(status);
    } else {
      Serial.println("JSON Parsing Failed!");
    }
  }

  delay(polling_rate);
}
