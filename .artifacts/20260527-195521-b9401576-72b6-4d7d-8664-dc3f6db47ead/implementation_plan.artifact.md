# Fix Profile Photo Upload Error

The user is experiencing a `[firebase_storage/object-not-found]` error when trying to upload a profile photo. This error typically occurs when `getDownloadURL()` is called on a reference that does not exist. This can happen if the upload failed or if there is a race condition.

## Proposed Changes

### Profile Feature

#### [profile_remote_data_source.dart](file:///C:/Users/victus/Desktop/BookShelf/bookshelf/lib/features/profile/data/datasources/profile_remote_data_source.dart)

- Refactor `uploadAvatar` to be more robust.
- Use nested `child()` calls for the storage path to avoid potential issues with slashes.
- Explicitly await the `UploadTask` and use the resulting `TaskSnapshot` to retrieve the download URL.
- Add basic validation for the provided bytes.

```dart
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
```

#### [profile_controller.dart](file:///C:/Users/victus/Desktop/BookShelf/bookshelf/lib/features/profile/presentation/providers/profile_controller.dart)

- Add a check for `bytes.isNotEmpty` before proceeding with the upload.

---

### UI Improvements

#### [profile_screen.dart](file:///C:/Users/victus/Desktop/BookShelf/bookshelf/lib/features/profile/presentation/profile_screen.dart)

- Improve error reporting in the `SnackBar`.
- If the error is `[firebase_storage/object-not-found]`, suggest checking if Firebase Storage is enabled in the console.

## Verification Plan

### Manual Verification
- I will verify the code changes by reviewing the logic and ensuring it follows best practices for `firebase_storage`.
- Since I cannot run the app with a real Firebase project, I will provide the user with instructions on how to verify it on their side:
    1. Check if "Firebase Storage" is enabled in the Firebase Console (click "Get Started" if not already done).
    2. Check the "Rules" tab in Firebase Storage and ensure they allow reads and writes to `users/{userId}/...`.
    3. Run the app and try to upload a photo again.
