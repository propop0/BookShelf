import 'package:firebase_auth/firebase_auth.dart';

import '../../../../l10n/app_localizations.dart';

String mapAuthException(Object error, AppLocalizations l10n) {
  if (error is FirebaseAuthException) {
    return switch (error.code) {
      'invalid-email' => l10n.authInvalidEmail,
      'user-disabled' => l10n.authUserDisabled,
      'user-not-found' => l10n.authUserNotFound,
      'wrong-password' => l10n.authWrongPassword,
      'email-already-in-use' => l10n.authEmailInUse,
      'weak-password' => l10n.authWeakPassword,
      'invalid-credential' => l10n.authInvalidCredential,
      'too-many-requests' => l10n.authTooManyRequests,
      _ => error.message ?? l10n.authFailed,
    };
  }
  return error.toString();
}
