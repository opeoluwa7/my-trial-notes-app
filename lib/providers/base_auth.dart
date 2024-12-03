import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/providers/db_provider.dart';
import 'package:provider/provider.dart';

class Auth extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  //to create user
  Future createUser(String email, String password, String firstName,
      String lastName, BuildContext context) async {
    try {
      //create user in firebase auth
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      //create userdata object
      UserModel userData =
          UserModel(email: email, firstName: firstName, lastName: lastName);

      final uid = currentUser?.uid;

      //add user profile data to firestore database
      //await firestoreService.addUser(userData);
      //using add generates a new id which is not what is intended in this app
      // and so using set helps specify
      await context
          .read<DbProvider>()
          .users
          .doc(uid)
          .collection('userInfo')
          .doc('info')
          .set(userData.toMap());

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      print('Process failed because $e');
      rethrow;
    }
  }

  //to sign in user
  Future<UserCredential> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      notifyListeners();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      String errorMessage = handleAuthError(e.code);
      throw FirebaseAuthException(
        message: errorMessage,
        code: e.code,
        credential: e.credential,
      );
    }
  }

  //to sign out
  Future signOut() async {
    await auth.signOut();
    notifyListeners();
  }

  Future deleteUser() async {
    await auth.currentUser?.delete();
    notifyListeners();
  }

  // Handle FirebaseAuth errors
  String handleAuthError(String errorCode) {
    debugPrint('handleAuthError called with errorCode: $errorCode');
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'invalid-credential':
        return 'Invalid credentials';
      case 'user-disabled':
        return 'User disabled';
      case 'email-already-in-use':
        return 'Email already in use';
      case 'wrong-password':
        return 'Incorrect password';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'network-request-failed':
        return 'Network request failed';
      default:
        return 'Something went wrong';
    }
  }
}
