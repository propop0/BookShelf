class FirestoreConstants {
  const FirestoreConstants._();

  static const String usersCollection = 'users';
  static const String librarySubcollection = 'library';

  static String userDoc(String userId) => '$usersCollection/$userId';
  static String libraryCollection(String userId) =>
      '$usersCollection/$userId/$librarySubcollection';
  static String libraryDoc(String userId, String workId) =>
      '${libraryCollection(userId)}/$workId';
}
