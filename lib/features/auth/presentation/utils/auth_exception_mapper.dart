import 'package:firebase_auth/firebase_auth.dart';

String mapAuthException(Object error) {
  if (error is FirebaseAuthException) {
    return switch (error.code) {
      'invalid-email' => 'Invalid email address.',
      'user-disabled' => 'This account has been disabled.',
      'user-not-found' => 'No account found for this email.',
      'wrong-password' => 'Incorrect password.',
      'email-already-in-use' => 'An account already exists for this email.',
      'weak-password' => 'Password is too weak. Use at least 6 characters.',
      'invalid-credential' => 'Invalid email or password.',
      'too-many-requests' => 'Too many attempts. Try again later.',
      _ => error.message ?? 'Authentication failed.',
    };
  }
  return error.toString();
}
