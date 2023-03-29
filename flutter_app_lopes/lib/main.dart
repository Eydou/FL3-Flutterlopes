import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lopes/pages/signIn.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_lopes/pages/auth.dart';
import 'package:flutter_app_lopes/bloc/UserRepo.dart';
import 'firebase_options.dart';
import 'bloc/authBloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) {
    runApp(
        RepositoryProvider(
          create: (context) => UserRepository(),
          child: BlocProvider(
            create: (context) => AuthBloc(
              authRepository: RepositoryProvider.of<UserRepository>(context),
            ),
            child: MaterialApp(
              home: StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    // If the snapshot has user data, then they're already signed in. So Navigating to the Dashboard.
                    if (snapshot.hasData) {
                      //return const Dashboard();
                    }
                    // Otherwise, they're not signed in. Show the sign in page.
                    return SignIn();
                  }),
            ),
          ),
        )
    );
  });
}
