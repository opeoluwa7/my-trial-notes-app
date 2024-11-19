import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/auth/firebase_auth.dart';
import 'package:myapp/auth/firebase_service.dart';
import 'package:myapp/auth/users_data.dart';
import 'package:myapp/pages/home_page.dart';
import 'package:myapp/util/error_dialog.dart';
import 'package:myapp/util/my_button.dart';
import 'package:myapp/util/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.tooglePages});
  final VoidCallback tooglePages;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final BaseAuth auth = BaseAuth();
  final _formKey = GlobalKey<FormState>();
  final FirestoreService firestoreService = FirestoreService();

  String firstName = '';
  String lastName = '';

  void signUpUser() async {
    String email = emailController.text;
    String password = passwordController.text;
    firstName = firstNameController.text;
    lastName = lastNameController.text;

    //to create an object instance with the actual details
    if (_formKey.currentState?.validate() ?? false) {
      UserData userData =
          UserData(firstName: firstName, lastName: lastName, email: email);
      try {
        await auth.createUser(email, password, firstName, lastName);
        firestoreService.addUser(userData);
       if(mounted) {
         Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
       }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case "auth/invalid-email":
            errorMessage = "Your email address is badly formatted";
            break;
          case "auth/email-already-in-use":
            errorMessage = "This email, is already in use";
            break;
          default:
            debugPrint('Unexpected Firebase Authentication Error Code: ${e.code}');
            errorMessage = "An undefined Error happened";
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

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value != passwordController.text) {
      return 'Passwords don\'t match';
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
                const SizedBox(height: 50),
                //header text
                const Text(
                  'Welcome!',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                //text
                const Text(
                  'Join Us',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 50),
                //First name
                MyTextField(
                  controller: firstNameController,
                  hintText: 'Enter your first name...',
                  labelText: 'First Name',
                  validator: null,
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                //Last name
                MyTextField(
                  controller: lastNameController,
                  hintText: 'Enter your last name...',
                  labelText: 'Last Name',
                  validator: null,
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                //Email
                MyTextField(
                  controller: emailController,
                  hintText: 'Enter your email...',
                  labelText: 'Email',
                  validator: validateEmail,
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                //Password
                MyTextField(
                  controller: passwordController,
                  hintText: 'Enter your password...',
                  labelText: 'Password',
                  obscureText: true,
                  validator: validatePassword,
                ),
                const SizedBox(height: 10),
                //Confirm Password
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm your password...',
                  labelText: 'Confirm Password',
                  obscureText: true,
                  validator: validateConfirmPassword,
                ),
                const SizedBox(height: 30),

                //Sign up button
                MyButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      signUpUser();
                    }
                  },
                  text: 'Sign Up',
                ),
                const SizedBox(height: 20),
                //go back to login
                GestureDetector(
                  onTap: widget.tooglePages,
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(text: 'Already a member?'),
                        TextSpan(text: '    '),
                        TextSpan(
                          text: 'Log In',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
