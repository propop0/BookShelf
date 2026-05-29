import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/constants/firestore_constants.dart';
import '../models/user_profile_model.dart';

class ProfileRemoteDataSource {
  const ProfileRemoteDataSource({
    required this._firestore,
    required this._storage,
  });

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  Stream<UserProfileModel?> watchProfile(String userId) {
    return _firestore
        .doc(FirestoreConstants.userDoc(userId))
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      return UserProfileModel.fromFirestore(snapshot);
    });
  }

  Future<void> ensureProfile({
    required String userId,
    required String email,
  }) async {
    final DocumentReference<Map<String, dynamic>> doc =
        _firestore.doc(FirestoreConstants.userDoc(userId));
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await doc.get();
    if (!snapshot.exists) {
      await doc.set(
        UserProfileModel(userId: userId, email: email).toFirestore(email: email),
      );
    }
  }

  Future<String> uploadAvatar({
    required String userId,
    required Uint8List bytes,
  }) async {
    if (bytes.isEmpty) {
      throw Exception('Cannot upload empty image.');
    }

    final Reference ref = _storage.ref().child('users').child(userId).child('avatar.jpg');

    // Using putData returns an UploadTask which is a Future<TaskSnapshot>
    final TaskSnapshot snapshot = await ref.putData(
      bytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    // Use the reference from the snapshot to ensure consistency
    final String downloadUrl = await snapshot.ref.getDownloadURL();

    await _firestore.doc(FirestoreConstants.userDoc(userId)).set(
      <String, dynamic>{
        'photoUrl': downloadUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    return downloadUrl;
  }
}
