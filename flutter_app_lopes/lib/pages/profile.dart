import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
      Padding(
      padding: EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
          child: ProfilePicture(),
      ),
          InformationProfile(context),
        ],
      ),
    );
  }
}

Row ProfilePicture() {
return Row(
  mainAxisSize: MainAxisSize.max,
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    CircleAvatar(
      radius: 35,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(1), // Border radius
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
          },
          child: ClipOval(
              child: Image.network(
                  'https://media.licdn.com/dms/image/C5603AQFxIX8VwOWAIQ/profile-displayphoto-shrink_800_800/0/1554474920022?e=2147483647&v=beta&t=ONX58uRfw7aX4VuTgPda2pn2Y8YKa0tPTIY_3aN1Yrg')),
        ),
      ),
    ),
  Padding(
  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
  child: Text(
  'Alexis Lopes',
  ),)
  ],
);
}

Padding InformationProfile(BuildContext context) {
  return Padding(
    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
    child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
    Padding(
    padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
    child: Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x33000000),
            offset: Offset(0, 2),
          )
        ],
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),
  ]
  )
  );
}