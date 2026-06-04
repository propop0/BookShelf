import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource);

  final FirebaseAuthDataSource _dataSource;

  @override
  Stream<User?> authStateChanges() => _dataSource.authStateChanges();

  @override
  User? get currentUser => _dataSource.currentUser;

  @override
  Future<void> signIn({required String email, required String password}) async {
    await _dataSource.signIn(email: email, password: password);
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    await _dataSource.signUp(email: email, password: password);
  }

  @override
  Future<void> signOut() => _dataSource.signOut();

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    return _dataSource.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signInWithGoogle() => _dataSource.signInWithGoogle();
}
