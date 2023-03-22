import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_lopes/homepage/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) {
    runApp(
        MaterialApp(
            home: HomePage(),
          debugShowCheckedModeBanner: false,
        ));
  });
}
