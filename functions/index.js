/* eslint-disable no-console, no-control-regex*/
const functions = require("firebase-functions");

const admin = require("firebase-admin");
const messagebird = require("messagebird")("LmmHoPyrSv5TM8WR0UktxvXJL");
admin.initializeApp();

exports.updateIndex = functions.firestore
  .document("user_requests/{id}")
  .onCreate(async (changes) => {
    const newData = changes.after.data();

    var params = {
      originator: "TestMessage",
      recipients: ["+919942648418"],
      body: "This is a test message",
    };

    messagebird.messages.create(params, function (err, response) {
      if (err) {
        return console.log(err);
      }
      console.log(response);
    });

    var payLoad = {
      notification: {
        title: "Your have a new friend request 🤩",
        body: `${newData["requestedBy"]} has accepted your request!`,
        sound: "default",
      },
      data: {
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        message: "Request has been accepted",
      },
    };
    try {
      await admin.messaging().sendToDevice(newData["deviceToken"], payLoad);
      console.log("Notification sent");
    } catch (err) {
      console.log(err);
    }
    return index.saveObject({ ...newData, objectID });
  });
