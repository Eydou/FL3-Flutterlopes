import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { UserRecord } from "firebase-functions/v1/auth";

const app = admin.initializeApp();
const db = admin.firestore(app);

export const createUserDoc = functions.auth
  .user()
  .onCreate(async (user: UserRecord) => {
    console.log(user);
    return await db
      .collection('users')
      .doc(user.uid)
      .create({ email: user.email, username: user.displayName, uid: user.uid, picture: 'https://firebasestorage.googleapis.com/v0/b/firelopes-e1fe1.appspot.com/o/icones%2Fd1.png?alt=media&token=f6727df5-8eb6-456b-b05f-4d087889742d' });
  });