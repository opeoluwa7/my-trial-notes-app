// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/home_page.dart';
import 'package:myapp/providers/base_auth.dart';
import 'package:myapp/util/my_button.dart';
import 'package:myapp/util/my_text_field.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, required this.tooglePages});
  final VoidCallback? tooglePages;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: LoginBody(
          tooglePages: tooglePages,
        ),
      ),
    );
  }
}

class LoginBody extends StatefulWidget {
  const LoginBody({super.key, this.tooglePages});
  final VoidCallback? tooglePages;

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    debugPrint("Error Dialog: $message");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
  }

  void _signInUser() async {
    String email = emailController.text;
    String password = passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _showErrorSnackBar(context, 'All fields are required');
    }
    if (password.length < 6) {
      _showErrorSnackBar(context, 'Password must be at least 6 characters');
    }
    try {
      showDialog(
          context: context,
          builder: (context) => const Center(
                child: CircularProgressIndicator.adaptive(),
              ));
      context.read<Auth>().signIn(email, password);
      if (mounted) {
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      errorMessage = context.read<Auth>().handleAuthError(e.code);
      _showErrorSnackBar(context, errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: columnBody(),
      ),
    );
  }

  Widget columnBody() {
    return Column(
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
          focusNode: emailFocusNode,
          controller: emailController,
          hintText: 'Enter your email...',
          labelText: 'Email',
          obscureText: false,
        ),
        const SizedBox(height: 20),
        //Password
        MyTextField(
          focusNode: passwordFocusNode,
          controller: passwordController,
          hintText: 'Enter your password...',
          labelText: 'Password',
          obscureText: true,
        ),
        const SizedBox(height: 30),
        //Login button
        MyButton(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
          textColor: Colors.black,
          onPressed: _signInUser,
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
    );
  }
}
