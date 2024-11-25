export const handler = async (event) => {
  let parsedPayload;

  try {
    // Parse the payload if it's a JSON string
    parsedPayload = event.body ? JSON.parse(event.body) : {};
  } catch (error) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: 'Invalid JSON payload',
        error: error.message,
      }),
    };
  }

  // Construct the response
  const response = {
    statusCode: 200,
    body: JSON.stringify({
      message: 'Payload received successfully!',
      payload: parsedPayload,
    }),
  };

  return response;
}