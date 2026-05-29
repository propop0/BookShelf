import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.userId,
    required super.email,
    super.displayName,
    super.photoUrl,
  });

  factory UserProfileModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final Map<String, dynamic> data = snapshot.data() ?? <String, dynamic>{};
    return UserProfileModel(
      userId: snapshot.id,
      email: (data['email'] as String?) ?? '',
      displayName: data['displayName'] as String?,
      photoUrl: data['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toFirestore({required String email}) {
    return <String, dynamic>{
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
