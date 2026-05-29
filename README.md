# BookShelf

A modern, feature-rich Flutter application for book enthusiasts. Search through millions of books, track your reading progress, and maintain your personal digital library with ease.

## Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (3.24+)
- **State Management**: [Riverpod](https://riverpod.dev/) (2.6+)
- **Backend**: [Firebase](https://firebase.google.com/) (Auth, Firestore, Storage)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
- **Architecture**: Clean Architecture (Feature-first organization)
- **API**: [Open Library API](https://openlibrary.org/developers/api)

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- A Firebase project (configured for Android/iOS/Web)

### Setup

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/your-username/bookshelf.git
    cd bookshelf
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Configure Firebase**:
    - Use [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup) to configure your Firebase project:
      ```bash
      flutterfire configure
      ```
    - Ensure `firebase_options.dart` is generated in `lib/`.

4.  **Run the app**:
    ```bash
    flutter run
    ```

## How to Use

### 1. Authentication
When you first open the app, you'll be greeted by the Login screen.
- **Sign Up**: Create a new account using your email and password.
- **Login**: Access your existing account.
- **Password Reset**: If you forget your password, use the "Forgot Password" feature to receive a reset link.

[Insert Screenshot Here: Login Screen]

### 2. Discovering Books (Home Screen)
The Home screen is your starting point for discovery.
- **Trending**: Browse books that are currently popular.
- **Categories**: Explore books by genres like Fantasy, Science Fiction, History, and more.
- **Search**: Use the search bar to find books by title or author.

[Insert Screenshot Here: Home Screen with Trending]

### 3. Search Results & Details
- **Search Results**: View a list of books matching your query.
- **Book Details**: Tap on any book to see its full description, author information, publication year, and related subjects.
- **Hero Animations**: Enjoy smooth transitions as book covers fly between screens.

[Insert Screenshot Here: Book Details Screen]

### 4. Personal Library
Manage your reading list in the "My Library" tab.
- **Add to Library**: From the Book Details screen, tap "Add to Library".
- **Status Tracking**: Categorize books as "Reading", "Read", or "Want to read".
- **Reading Progress**: For books you are currently "Reading", track your progress by updating your current page. The app will calculate your percentage automatically.
- **Ratings & Reviews**: Leave a rating (1-10) and a short review for books you've read.

[Insert Screenshot Here: My Library with Progress Bars]
[Insert Screenshot Here: Editing Book Progress]

### 5. Profile & Settings
Customize your experience in the Profile tab.
- **Profile Photo**: Upload or change your profile picture using your camera or gallery (stored in Firebase Storage).
- **Statistics**: View your reading stats, including books read, average rating, and favorite genre.
- **Dark/Light Theme**: Toggle between light and dark modes to suit your preference.
- **Localization**: Change the app language (available in English, Ukrainian, and Polish).

[Insert Screenshot Here: Profile Screen]

## Features Implementation Details

- **Animations**: Uses `Hero` animations for covers and `FadeInAnimation` for list items to provide a polished UX.
- **Clean Architecture**: Decoupled layers (Domain, Data, Presentation) for better maintainability and testability.
- **Responsive Layout**: Designed to look great on various screen sizes using Material Design 3.

## Testing

The project includes a comprehensive test suite:
- **Unit Tests**: Logic for stats calculation, progress tracking, and model parsing.
- **Widget Tests**: Verification of core UI components like cards and pills.

Run tests using:
```bash
flutter test
```
