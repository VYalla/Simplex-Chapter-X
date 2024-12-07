/* eslint-disable arrow-parens */
/* eslint-disable max-len */
const {onRequest} = require("firebase-functions/v2/https");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNotif = onRequest(async (req, res) => {
  const {topic, title, body} = req.body; // Extract parameters from request body

  if (!topic || !title || !body) {
    res.status(400).send({success: false, message: "Missing required fields: topic, title, or body."});
    return;
  }

  const message = {
    notification: {
      title,
      body,
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
    topic,
  };

  try {
    const response = await admin.messaging().send(message);
    console.log("Notification sent successfully:", response);
    res.status(200).send({success: true, message: "Notification sent successfully", response});
  } catch (error) {
    console.error("Error sending notification:", error);
    res.status(500).send({success: false, message: "Error sending notification", error: error.message});
  }
});
