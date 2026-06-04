# Implementation Plan - Enhancements and Fixes

This plan outlines the changes to activate Google Login, allow manual book addition, integrate a better API for Ukrainian books, and fix UI issues.

## User Review Required

> [!IMPORTANT]
> - **Google Sign-In**: Requires the user to have added the `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) with the necessary OAuth client IDs. The screenshot suggests these are being handled.
> - **Manual Book ID**: Manual books will use a unique prefix (e.g., `manual_`) followed by a UUID to avoid collisions with OpenLibrary/Google Books IDs.

## Proposed Changes

### 1. Authentication (Google Sign-In)
Activate Google Login as requested.

#### [pubspec.yaml](file:///C:/Users/victus/Desktop/BookShelf/bookshelf/pubspec.yaml)
- Add `google_sign_in: ^6.2.1` dependency.

#### [firebase_auth_data_source.dart](file:///C:/Users/victus/Desktop/BookShelf/bookshelf/lib/features/auth/data/datasources/firebase_auth_data_source.dart)
- Implement `signInWithGoogle()` using the `google_sign_in` package.

#### [auth_repository.dart](file:///C:/Users/victus/Desktop/BookShelf/bookshelf/lib/features/auth/domain/repositories/auth_repository.dart) & [auth_repository_impl.dart](file:///C:/Users/victus/Desktop/BookShelf/bookshelf/lib/features/auth/data/repositories/auth_repository_impl.dart)
- Add and implement `signInWithGoogle()` method.

#### [auth_controller.dart](file:///C:/Users/victus/Desktop/BookShelf/bookshelf/lib/features/auth/presentation/providers/auth_controller.dart)
- Add `signInWithGoogle()` to the controller.

#### [login_screen.dart](file:///C:/Users/victus/Desktop/BookShelf/bookshelf/lib/features/auth/presentation/login_screen.dart)
- Add a "Sign in with Google" button below the email/password form.

---

### 2. Manual Book Addition
Allow users to add books that weren't found in the search.

#### [NEW] [add_manual_book_screen.dart](file:///C:/Users/victus/Desktop/BookShelf/bookshelf/lib/features/book_catalog/presentation/add_manual_book_screen.dart)
- A form to input book details (title, authors, optional page count).
- Logic to save this book directly to the user's library.

#### [search_results_screen.dart](file:///C:/Users/victus/Desktop/BookShelf/bookshelf/lib/features/search/presentation/search_results_screen.dart)
- Add a button "Add Manually" when the search results are empty.

---

### 3. Ukrainian Book API Integration
Integrate Google Books API to improve search results for Ukrainian books.

#### [api_constants.dart](file:///C:/Users/victus/Desktop/BookShelf/bookshelf/lib/core/constants/api_constants.dart)
- Add Google Books API base URL and search path.

#### [NEW] [google_books_remote_data_source.dart](file:///C:/Users/victus/Desktop/BookShelf/bookshelf/lib/features/book_catalog/data/datasources/google_books_remote_data_source.dart)
- Implement search using Google Books API with `langRestrict=uk`.

#### [book_repository_impl.dart](file:///C:/Users/victus/Desktop/BookShelf/bookshelf/lib/features/book_catalog/data/repositories/book_repository_impl.dart)
- Modify `searchBooks` to fetch from both OpenLibrary and Google Books in parallel and merge results.

---

### 4. UI Fixes & Web Avatar
Remove annoying progress bars and fix web avatar display.

#### [profile_screen.dart](file:///C:/Users/victus/Desktop/BookShelf/bookshelf/lib/features/profile/presentation/profile_screen.dart)
- Update avatar rendering to use a widget that handles CORS issues on web (e.g., using an `Image` widget with a specific renderer or checking for `kIsWeb`).

#### [library_entry_tile.dart](file:///C:/Users/victus/Desktop/BookShelf/bookshelf/lib/features/library/presentation/widgets/library_entry_tile.dart)
- Remove the `LinearProgressIndicator` that shows when the total page count is being fetched but current page is known.

#### [app_uk.arb](file:///C:/Users/victus/Desktop/BookShelf/bookshelf/lib/l10n/app_uk.arb) (and other locales)
- Add necessary strings for Google Sign-In and Manual Book addition.

## Verification Plan

### Automated Tests
- N/A (Project doesn't seem to have comprehensive integration tests for UI flows yet, but I will check `test/` directory).

### Manual Verification
1. **Google Login**: Verify the button appears and triggers the Google sign-in flow (simulated if needed, or verified by code structure).
2. **Search Results**: Search for a non-existent book and verify the "Add Manually" button appears.
3. **Manual Addition**: Fill the form and verify the book appears in "My Library".
4. **Ukrainian Books**: Search for "Лісова пісня" and verify results from Google Books appear.
5. **Progress Bar**: Open "My Library" and verify the loading bar in tiles is gone.
