import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/auth_gate.dart';
import 'package:myapp/providers/base_auth.dart';
import 'package:myapp/providers/db_provider.dart';
import 'package:myapp/util/delete_dialog.dart';
import 'package:myapp/util/text_button.dart';
import 'package:myapp/util/user_tiles.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
  });

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
      body: const ProfileFutureBody(),
    );
  }
}

class ProfileFutureBody extends StatefulWidget {
  const ProfileFutureBody({super.key});

  @override
  State<ProfileFutureBody> createState() => _ProfileFutureBodyState();
}

class _ProfileFutureBodyState extends State<ProfileFutureBody> {
  final User currentUser = FirebaseAuth.instance.currentUser!;

  Future<void> signUserOut() async {
    await context.read<Auth>().signOut();
    if (mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MainPage()));
    }
  }

  Future<Map<String, dynamic>>? fetchUserData() async {
    try {
      final userData =
          await context.watch<DbProvider>().fetchUserData(currentUser.uid);
      if (userData != null) {
        return userData.toMap();
      } else {
        return {'firstName': 'N/A', 'lastName': 'N/A', 'email': 'N/A'};
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
      rethrow;
    }
  }

  Future<void> deleteUserAcc() async {
    await context.read<DbProvider>().deleteUserInfo(context, currentUser.uid);
  }

  Future<void> deleteAccount() async {
    await showDialog(
      context: context,
      builder: (context) => DeleteDialog(
        onPressed: () {
          Navigator.pop(context);
          deleteUserAcc();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
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
      },
    );
  }
}
