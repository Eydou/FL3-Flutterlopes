import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> uploadProfilePicture(String filePath) async {
  final user = FirebaseAuth.instance.currentUser;
  final fileName = 'profile_picture_${user!.uid}.jpg';
  final ref = firebase_storage.FirebaseStorage.instance
      .ref('users/${user.uid}/profilePictures/$fileName');

  try {
    final uploadTask = ref.putFile(File(filePath));
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'picture': downloadUrl});
  } catch (e) {
    print('Error uploading profile picture: $e');
  }
}

class ProfilePictureStream {
  StreamController<String?> _streamController = StreamController<String?>();

  ProfilePictureStream() {
    final user = FirebaseAuth.instance.currentUser;
    final userRef = FirebaseFirestore.instance.collection('users').doc(user!.uid);
    userRef.snapshots().listen((docSnapshot) {
      if (docSnapshot.exists) {
        final profilePictureUrl = docSnapshot.get('picture');
        _streamController.add(profilePictureUrl);
      }
    });
  }

  Stream<String?> get stream => _streamController.stream;

  void dispose() {
    _streamController.close();
  }
}