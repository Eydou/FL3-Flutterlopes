import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lopes/bloc/authBloc.dart';
import 'package:flutter_app_lopes/pages/home.dart';
import 'package:flutter_app_lopes/pages/profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/signIn.dart';

class NavigationDrawerLopes  extends StatelessWidget {
  const NavigationDrawerLopes({super.key});

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
        onTap: () {
          BlocProvider.of<AuthBloc>(context).add(
          SignOutRequested());
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => SignIn()));
        },
      )
    ],
  );
}