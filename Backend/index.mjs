import {
  IoTDataPlaneClient,
  PublishCommand,
} from "@aws-sdk/client-iot-data-plane";

// // Initialize IoT Data Plane client
const client = new IoTDataPlaneClient({
  region: process.env.AWS_IOT_REGION,
});

export const handler = async (event) => {
  console.log("Received event:", JSON.stringify(event, null, 2));
  if (!process.env.AWS_IOT_TOPIC || !process.env.AWS_IOT_REGION) {
    console.error("Missing required environment variables.");
    return {
      statusCode: 500,
      body: JSON.stringify({
        error: "Server Error.",
      }),
    };
  }

  let status;
  try {
    const data = JSON.parse(event.body);
    status = data.status ? data.status : "unknown";
  } catch (e) {
    status = "unknown";
  }

  const params = {
    topic: process.env.AWS_IOT_TOPIC,
    payload: JSON.stringify({ status }),
    qos: 0,
  };
  console.log("Publishing message: ", params.payload);

  const command = new PublishCommand(params);
  try {
    // Publish message to IoT Core topic
    await client.send(command);
    console.log("Message published successfully");
    return {
      statusCode: 200,
      body: JSON.stringify({
        message: "published successfully",
        topic: params.topic,
      }),
    };
  } catch (err) {
    console.error("Error publishing message:", err);
    return {
      statusCode: 500,
      body: JSON.stringify({
        error: "Failed to publish",
        topic: params.topic,
        details: err.message,
        stack: err.stack,
      }),
    };
  }
};
