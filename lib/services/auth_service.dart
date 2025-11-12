import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {
        'success': true,
        'user': userCredential.user,
        'message': 'Registration successful',
      };
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Registration failed';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is invalid.';
      }
      return {
        'success': false,
        'user': null,
        'message': errorMessage,
      };
    } catch (e) {
      return {
        'success': false,
        'user': null,
        'message': 'An unexpected error occurred: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {
        'success': true,
        'user': userCredential.user,
        'message': 'Sign in successful',
      };
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Sign in failed';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is invalid.';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'This user account has been disabled.';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Too many requests. Please try again later.';
      }
      return {
        'success': false,
        'user': null,
        'message': errorMessage,
      };
    } catch (e) {
      return {
        'success': false,
        'user': null,
        'message': 'An unexpected error occurred: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> signOut() async {
    try {
      await _auth.signOut();
      return {
        'success': true,
        'message': 'Signed out successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error signing out: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> changePassword(String newPassword) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        return {
          'success': false,
          'message': 'No user is currently signed in.',
        };
      }
      await user.updatePassword(newPassword);
      return {
        'success': true,
        'message': 'Password changed successfully',
      };
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Password change failed';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'requires-recent-login') {
        errorMessage =
            'This operation requires recent authentication. Please sign in again.';
      }
      return {
        'success': false,
        'message': errorMessage,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
      };
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}

