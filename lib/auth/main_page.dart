import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/auth/firebase_auth.dart';
import 'package:myapp/pages/home_page.dart';
import 'package:myapp/pages/login_or_register.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});
  final BaseAuth auth = BaseAuth();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const LoginOrRegister();
        }
      },
    );
  }
}
