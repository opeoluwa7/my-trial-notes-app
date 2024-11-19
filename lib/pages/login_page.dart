

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/auth/firebase_auth.dart';
import 'package:myapp/pages/home_page.dart';
import 'package:myapp/util/error_dialog.dart';
import 'package:myapp/util/my_button.dart';
import 'package:myapp/util/my_text_field.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback tooglePages;
  const LoginPage({super.key, required this.tooglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final BaseAuth auth = BaseAuth();
  final _formKey = GlobalKey<FormState>();
  String errorMessage = "";

  void signInUser() async {
    String email = emailController.text;
    String password = passwordController.text;
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await auth.signIn(email, password);
        if (mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case "auth/invalid-email":
            errorMessage = "Your email address is badly formatted";
            break;
          case "auth/wrong-password":
            errorMessage = "Your password is wrong";
            break;
          case "auth/user-not-found":
            errorMessage = "No user exists with this email";
            break;
          case "auth/invalid-credential":
            errorMessage = "Invalid Credentials";
            break;
          case "auth/too-many-requests":
            errorMessage = "Too many requests. Try again later";
            break;
          default:
            errorMessage = "An exception occured, please try again later";
        }
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(errorMessage: errorMessage);
            },
          );
        }
      }
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 150),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Log in',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 50),
                //Email
                MyTextField(
                  controller: emailController,
                  hintText: 'Enter your email...',
                  labelText: 'Email',
                  validator: validateEmail,
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                //Password
                MyTextField(
                  controller: passwordController,
                  hintText: 'Enter your password...',
                  labelText: 'Password',
                  validator: validatePassword,
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                //Login button
                MyButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      signInUser();
                    }
                  },
                  text: 'Log In',
                ),
                const SizedBox(height: 20),
                //go to register
                GestureDetector(
                  onTap: widget.tooglePages,
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(text: 'Are you new to this space?'),
                        TextSpan(text: '    '),
                        TextSpan(
                          text: 'Join us',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
