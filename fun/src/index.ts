import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();

export const sendNotificationOnComment = functions.firestore
  .document("comments/{commentId}")
  .onCreate(async (commentSnapshot: admin.firestore.QueryDocumentSnapshot) => {
    const comment = commentSnapshot.data();
    if (!comment) {
      console.error("Comment data not found");
      return null;
    }

    const postSnapshot = await db.collection("posts").doc(comment.postId).get();
    const post = postSnapshot.data();

    if (!post) {
      console.error("Post data not found");
      return null;
    }

    const userRef = post.userInfo as admin.firestore.DocumentReference;

    const userDoc = await userRef.get();

    if (userDoc.exists) {
      // notification text
      const username = userDoc.data()?.username;
      const commentText = comment.commentText;

      // getting fcmToken
      const tokensSnapshot = await userRef.collection("userToken").get();

      if (tokensSnapshot.empty) {
        console.log("Token is empty");
        return;
      }

      const promises: Promise<any>[] = [];

      tokensSnapshot.forEach(async (tokenDoc) => {
        const fcmToken = tokenDoc.id;
        console.log(`fcmToken ${fcmToken}`);

        const payload: admin.messaging.Message = {
          notification: {
            title: "New comment!",
            body: `${username} leave a comment to your post: "${commentText}"`,
          },
          token: fcmToken,
        };
        console.log(`payload: ${payload}`);
        const promise = admin.messaging().send(payload).catch((error) => {
          console.log("Notification sending error:", error);
        });

        promises.push(promise);

        // sending push notification
        await Promise.all(promises);
      });
    }

    return null;
  });
