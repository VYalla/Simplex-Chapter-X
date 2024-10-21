/* eslint-disable arrow-parens */
/* eslint-disable max-len */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNotif = functions.https.onCall(async (data, context) => {
  const topic = data.topic;
  const title = data.title;
  const body = data.body;
  const message = {
    notification: {
      title: title,
      body: body,
    },
    android: {
      priority: "high",
    },
    apns: {
      payload: {
        aps: {
          contentAvailable: true,
          badge: 1,
        },
      },
    },
    topic: topic,
  };
  try {
    const response = await admin.messaging().send(message);
    console.log("Notification sent successfully:", response);
    return {"success": true, "message": "Notification sent successfully"};
  } catch (error) {
    console.error("Error sending notification:", error);
    return {"success": false, "message": "Error sending notification"};
  }
});

exports.deleteUserById = functions.https.onCall(async (data, context) => {
  try {
    // Check if the request is authenticated and the user has admin privileges
    if (!context.auth) {
      throw new functions.https.HttpsError(
          "permission-denied",
          "You do not have the necessary permissions to delete a user.",
      );
    }

    // Get the user ID from the request data
    const userId = data.id;

    // Delete the user
    await admin.auth().deleteUser(userId);

    return {message: "User deleted successfully."};
  } catch (error) {
    console.error("Error deleting user:", error);
    throw new functions.https.HttpsError(
        "internal",
        "An error occurred while deleting the user.",
    );
  }
});
