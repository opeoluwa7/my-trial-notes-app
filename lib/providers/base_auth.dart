import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:myapp/models/user_model.dart';

class Auth extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;

  //to create user
  Future<void> createUser(String email, String password, String firstName,
      String lastName, Function onCreateUser) async {
    try {
      //create user in firebase auth
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;

      if (uid != null) {
        //create userdata object
        UserModel userData =
            UserModel(email: email, firstName: firstName, lastName: lastName);
        //add user profile data to firestore database
        onCreateUser(userData, uid);
        notifyListeners();
      } else {
        throw FirebaseAuthException(
          message: 'User creation failed. No UID generated.',
          code: 'no-uid',
        );
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Process failed because $e');
      rethrow;
    }
  }

  //to sign in user
  Future<UserCredential?> signIn(
    String email,
    String password,
  ) async {
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
      case 'channel-error':
        return 'Channel Error';
      default:
        return 'Something went wrong';
    }
  }

}
