import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { UserRecord } from "firebase-functions/v1/auth";

const app = admin.initializeApp();
const db = admin.firestore(app);

export const createUserDocument = functions.auth
  .user()
  .onCreate(async (user: UserRecord) => {
    await db
      .collection("users")
      .doc(user.uid)
      .set({ email: user.email, username: "", uid: user.uid, recipes: []});

    await db
      .collection("Groups")
      .doc("User")
      .update({
        users: admin.firestore.FieldValue.arrayUnion(user.uid),
      });
  });