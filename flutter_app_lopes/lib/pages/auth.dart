import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_lopes/bloc/UserRepo.dart';
import 'package:flutter_app_lopes/bloc/authBloc.dart';
import 'package:flutter_app_lopes/pages/signIn.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocLoginPage extends StatelessWidget {
  const BlocLoginPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => UserRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: RepositoryProvider.of<UserRepository>(context),
        ),
        child: MaterialApp(
            home: SignIn()
        ),
      ),
    );
  }
}