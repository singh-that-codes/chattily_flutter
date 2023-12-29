const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();

exports.sendMessage = functions.firestore
    .document("users/{user_id}/chats/{chat_id}/messages/{message_id}")
    .onCreate(async (messageSnapshot, context) => {
      const message = messageSnapshot.data();
      const receiverTokens = [];
      let senderData;

      await admin
          .firestore()
          .collection("users")
          .get()
          .then((r) => {
            if (r.empty) {
              console.log("No matching documents.");
              return;
            }
            r.forEach((doc) => {
              if (doc.id == message.receiver) {
                for (let t = 0; t < doc.data().tokens.length; t++) {
                  const element = doc.data().tokens[t];
                  receiverTokens.push(element);
                }
              }
              if (doc.id == message.sender) {
                senderData = doc.data();
              }
            });
          });

      const receiverMessagePayload = {
        data: {
          click_action: "FLUTTER_NOTIFICATION_CLICK",
          user: senderData.id,
          photo: senderData.photo,
          name: senderData.name,
          email: senderData.email,
          id: message.id,
          text: message.text,
          sender: message.sender,
          receiver: message.receiver,
        },
      };

      if (message.sent == false) {
        if (message.receiver != message.sender) {
          await db
              .collection("users")
              .doc(message.sender)
              .collection("chats")
              .doc(message.receiver)
              .collection("messages")
              .doc(message.id)
              .update({
                sent: true,
              })
              .then(async () => {
                await db
                    .collection("users")
                    .doc(message.receiver)
                    .collection("chats")
                    .doc(message.sender)
                    .collection("messages")
                    .doc(message.id)
                    .set({
                      id: message.id,
                      text: message.text,
                      receiver: message.receiver,
                      sender: message.sender,
                      time: message.time,
                      sent: true,
                    })
                    .then(async () => {
                      await admin
                          .messaging()
                          .sendToDevice(receiverTokens, receiverMessagePayload);
                    });
              });
        }
      }
    });
