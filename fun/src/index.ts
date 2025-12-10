import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();

export const sendNotificationOnLike = functions.firestore
  .document("likes/{likeId}")
  .onCreate(async (likeSnapshot: admin.firestore.QueryDocumentSnapshot) => {
    const like = likeSnapshot.data();
    if (!like) {
      console.error("Like data not found");
      return null;
    }
    const postSnapshot = await db.collection("posts").doc(like.postId).get();
    const post = postSnapshot.data();

    if (!post) {
      console.error("Post data not found");
      return null;
    }

    const postOwnerRef = post.userInfo as admin.firestore.DocumentReference;

    // get post owner token to send notification
    const tokensSnapshot = await postOwnerRef.collection("userToken").get();

    if (tokensSnapshot.empty) {
      console.log("Token is empty");
      return null;
    }

    // to get username of person who liked post
    const userSnapshot = await db.collection("users").doc(like.userId).get();
    const user = userSnapshot.data();

    if (!user) {
      console.error("User data not found");
      return null;
    }
    const username = user.username;

    const promises: Promise<any>[] = [];

    tokensSnapshot.forEach(async (tokenDoc) => {
      const fcmToken = tokenDoc.id;
      console.log(`fcmToken ${fcmToken}`);

      const payload: admin.messaging.Message = {
        notification: {
          title: "New like!",
          body: `${username} liked your post`,
        },
        token: fcmToken,
      };

      console.log(`payload: ${payload["notification"]}`);
      const promise = admin.messaging().send(payload).catch((error) => {
        console.log("Notification sending error:", error);
      });

      promises.push(promise);

      // sending push notification
      await Promise.all(promises);
    });
    return null;
  });

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

    const postOwnerRef = post.userInfo as admin.firestore.DocumentReference;
    // cOwnerRef = comment owner reference
    const cOwnerRef = comment.userInfo as admin.firestore.DocumentReference;

    // to get post owner fcmToken
    const userPostOwnerDoc = await postOwnerRef.get();
    // to get comment owner username
    const userCommentOwnerDoc = await cOwnerRef.get();

    if (userPostOwnerDoc.exists) {
      // const postOwnerUsername = userPostOwnerDoc.data()?.username;
      const commentText = comment.commentText;

      // getting fcmToken
      const tokensSnapshot = await postOwnerRef.collection("userToken").get();

      if (tokensSnapshot.empty) {
        console.log("Token is empty");
        return;
      }

      let username = "";
      if (userCommentOwnerDoc.exists) {
        username = userCommentOwnerDoc.data()?.username;
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
        console.log(`payload: ${payload["notification"]}`);
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
