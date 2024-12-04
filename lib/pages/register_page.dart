import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/providers/base_auth.dart';
import 'package:myapp/providers/db_provider.dart';
import 'package:myapp/util/my_button.dart';
import 'package:myapp/util/my_text_field.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key, required this.tooglePages});
  final VoidCallback tooglePages;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: RegisterBody(
          tooglePages: tooglePages,
        ),
      ),
    );
  }
}

class RegisterBody extends StatefulWidget {
  const RegisterBody({super.key, this.tooglePages});
  final VoidCallback? tooglePages;

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  // to display the error messages in a snackbar
  _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> signUpUser(BuildContext context) async {
    String firstName;
    String lastName;
    String confirmPassword;
    String email = emailController.text;
    String password = passwordController.text;
    firstName = firstNameController.text;
    lastName = lastNameController.text;
    confirmPassword = confirmPasswordController.text;

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return _showErrorSnackBar(context, 'All fields are required');
    }
    if (password.length < 6) {
      return _showErrorSnackBar(
          context, 'Password must be at least 6 characters');
    }
    if (password != confirmPassword) {
      return _showErrorSnackBar(context, 'Passwords do not match');
    }

    try {
      _cpiDialog();
      await _createUserMethod(context, email, password, firstName, lastName);
      _successfulSignUp();
    } on FirebaseAuthException catch (e) {
      _firebaseError(e);
    } catch (e) {
      _genericError();
    }
  }

  void _successfulSignUp() {
    if (mounted) {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _cpiDialog() {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  // this creates the user in firebase auth and stores the user data in firestore
  Future<void> _createUserMethod(
    context,
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    // auth
    await context.read<Auth>().createUser(email, password, firstName, lastName,
        (userData, uid) {
      //await firestoreService.addUser(userData);
      //using .add() generates a new id which is not what is intended in this app
      // and so using set helps specify

      //firestore db
      context
          .read<DbProvider>()
          .users
          .doc(uid)
          .collection('userInfo')
          .doc('info')
          .set(userData.toMap());
    });
  }

  // this displays firebase auth errors
  void _firebaseError(e) {
    String errorMessage;
    Navigator.pop(context);
    errorMessage = context.read<Auth>().handleAuthError(e.code);
    _showErrorSnackBar(context, errorMessage);
  }

  // this displays generic errors like network connectivity
  void _genericError() {
    Navigator.pop(context);
    _showErrorSnackBar(context, 'Something went wrong, Please try again');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(child: columnBody()),
      ),
    );
  }

  Widget columnBody() {
    return Column(
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
          focusNode: firstNameFocusNode,
          controller: firstNameController,
          hintText: 'Enter your first name...',
          labelText: 'First Name',
          obscureText: false,
        ),
        const SizedBox(height: 10),
        //Last name
        MyTextField(
          focusNode: lastNameFocusNode,
          controller: lastNameController,
          hintText: 'Enter your last name...',
          labelText: 'Last Name',
          obscureText: false,
        ),
        const SizedBox(height: 10),
        //Email
        MyTextField(
          focusNode: emailFocusNode,
          controller: emailController,
          hintText: 'Enter your email...',
          labelText: 'Email',
          obscureText: false,
        ),
        const SizedBox(height: 10),
        //Password
        MyTextField(
          focusNode: passwordFocusNode,
          controller: passwordController,
          hintText: 'Enter your password...',
          labelText: 'Password',
          obscureText: true,
        ),
        const SizedBox(height: 10),
        //Confirm Password
        MyTextField(
          focusNode: confirmPasswordFocusNode,
          controller: confirmPasswordController,
          hintText: 'Confirm your password...',
          labelText: 'Confirm Password',
          obscureText: true,
        ),
        const SizedBox(height: 30),

        //Sign up button
        MyButton(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
          textColor: Colors.black,
          onPressed: () => signUpUser(context),
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
        ),
      ],
    );
  }
}
