import 'package:flutter/material.dart';
import 'package:flutter_app_lopes/pages/home.dart';
import 'package:flutter_app_lopes/pages/profile.dart';

class NavigationDrawer  extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
    width: 240,
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildHeader(context),
          buildMenuItems(context),
        ],
      ),
    ),
  );
  Widget buildHeader(BuildContext context) => Container(
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top,
    ),
  );
  Widget buildMenuItems(BuildContext context) => Column(
    children: [
      ListTile(
        leading: const Icon(Icons.person_outline),
        title: const Text("Profile"),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage()),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.shuffle),
        title: const Text("Setting"),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(Icons.shuffle),
        title: const Text("Logout"),
        onTap: () {},
      )
    ],
  );
}