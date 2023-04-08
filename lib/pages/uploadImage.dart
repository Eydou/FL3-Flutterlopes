import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lopes/fonction/uploadImage.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureUploader extends StatefulWidget {
  final String userId;

  ProfilePictureUploader({Key ?key, required this.userId}) : super(key: key);

  @override
  _ProfilePictureUploaderState createState() => _ProfilePictureUploaderState();
}

class _ProfilePictureUploaderState extends State<ProfilePictureUploader> {
  File? _image;

  Future<String?> getProfilePictureUrl() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }

    final ref = FirebaseStorage.instance
        .ref('users/${user.uid}/profilePictures/profile_picture_${user.uid}.jpg');

    try {
      final downloadUrl = await ref.getDownloadURL();
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Image uploaded')));
      });
      return downloadUrl;
    } catch (e) {
      print('Error retrieving profile picture: $e');
      return null;
    }
  }

  Future getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
      getProfilePictureUrl();
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
    backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
    appBar: AppBar(
    title: Text("Profile Picture", style: TextStyle(color: Colors.black87),),
    iconTheme: IconThemeData(color: Colors.black87),
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    ),
    body: Center(child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 30.0),
        StreamBuilder<String?>(
          stream: ProfilePictureStream().stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data!),
                  radius: 80.0,
              );
            } else {
              return  CircularProgressIndicator();
            }
          },
        ),
        SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: () {
            getImage();
          },
          child: Text(
            'Change Profile Picture',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: () {
            uploadProfilePicture(_image!.path);
          },
          child: Text(
            'Save',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ],
    ))
    ));
  }
}
