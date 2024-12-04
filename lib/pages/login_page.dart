// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
  }

  void _signInUser() async {
    String email = emailController.text;
    String password = passwordController.text;

    try {
      _cpiDialog();
      await _signInUserMethod(context, email, password);
      _successfulLogin();
    } on FirebaseAuthException catch (e) {
      _firebaseError(e);
    } catch (e) {
      _genericError();
    }
  }

  void _successfulLogin() {
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _cpiDialog() {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  Future<void> _signInUserMethod(context, String email, String password) async {
    await context.read<Auth>().signIn(
          email,
          password,
        );
  }

  void _firebaseError(e) {
    String errorMessage;
    Navigator.pop(context);
    errorMessage = context.read<Auth>().handleAuthError(e.code);
    _showErrorSnackBar(context, errorMessage);
  }

  void _genericError() {
    Navigator.pop(context);
    _showErrorSnackBar(context, 'Something went wrong, Please try again');
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
