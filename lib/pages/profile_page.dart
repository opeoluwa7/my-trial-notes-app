import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/auth/firebase_auth.dart';
import 'package:myapp/auth/firebase_service.dart';
import 'package:myapp/pages/login_or_register.dart';
import 'package:myapp/util/delete_dialog.dart';
import 'package:myapp/util/my_button.dart';
import 'package:myapp/util/text_button.dart';
import 'package:myapp/util/user_tiles.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.firestoreService});
  final FirestoreService firestoreService;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User currentUser = FirebaseAuth.instance.currentUser!;
  final BaseAuth auth = BaseAuth();

  Future<void> signUserOut() async {
    await auth.signOut();
    if (mounted) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginOrRegister()));
    }
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    final userData =
        await widget.firestoreService.fetchUserData(currentUser.uid);
    if (userData != null) {
      return userData.toMap();
    } else {
      return {'firstName': 'N/A', 'lastName': 'N/A', 'email': 'N/A'};
    }
  }

  Future<void> deleteUserAcc() async {
    await widget.firestoreService.deleteProfileData(currentUser.uid);
    await auth.deleteUser();
  }

  Future<void> deleteAccount() async {
    await showDialog(
        context: context,
        builder: (context) => DeleteDialog(
              onPressed: () {
                deleteUserAcc();
                Navigator.pop(context);
              },
            ));
  }

  //I want to get the first name, last name, and email
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<Map<String, dynamic>>(
            future: fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Cannot retrive your details currently'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasData) {
                final user = snapshot.data as Map<String, dynamic>;
                final firstName = user['firstName'] ?? 'N/A';
                final lastName = user['lastName'] ?? 'N/A';
                final email = user['email'] ?? 'N/A';

                return Scaffold(
                  body: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Icon(
                        Icons.account_circle_rounded,
                        size: 100,
                        color: Colors.grey[400],
                      ),
                      UserTiles(text: 'FirstName: $firstName'),
                      UserTiles(text: 'LastName: $lastName'),
                      UserTiles(text: 'Email:        $email'),
                      const SizedBox(
                        height: 20,
                      ),
                      MyTextButton(
                        color: Colors.white,
                        iconColor: Colors.white,
                        text: 'Sign Out',
                        onPressed: signUserOut,
                        icon: Icons.login_rounded,
                        size: 16,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyTextButton(
                        color: Colors.red,
                        iconColor: Colors.red,
                        text: 'Delete account',
                        onPressed: deleteAccount,
                        icon: Icons.close,
                        size: 24,
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text('No user found'),
                );
              }
            }));
  }
}
