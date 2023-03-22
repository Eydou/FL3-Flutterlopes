import 'package:flutter/material.dart';

import '../widgets/navigation_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black87),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 15.0, top: 10),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: ClipRRect(
                    child: CircleAvatar(
                  radius: 56,
                  backgroundColor: Colors.grey,
                  child: Padding(
                    padding: const EdgeInsets.all(1), // Border radius
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {},
                      child: ClipOval(
                          child: Image.network(
                              'https://media.licdn.com/dms/image/C5603AQFxIX8VwOWAIQ/profile-displayphoto-shrink_800_800/0/1554474920022?e=2147483647&v=beta&t=ONX58uRfw7aX4VuTgPda2pn2Y8YKa0tPTIY_3aN1Yrg')),
                    ),
                  ),
                )),
              ),
            )
          ],
        ),
        drawer: const NavigationDrawer(),
      );
}
