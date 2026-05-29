// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BookShelf';

  @override
  String get navHome => 'Home';

  @override
  String get navLibrary => 'Library';

  @override
  String get navProfile => 'Profile';

  @override
  String get searchBooks => 'Search books';

  @override
  String get searchHint => 'e.g. Harry Potter';

  @override
  String get searchFieldLabel => 'Title or author';

  @override
  String get searchButton => 'Search';

  @override
  String get searchValidationEmpty => 'Please enter a search query.';

  @override
  String get searchValidationMinLength => 'Use at least 2 characters.';

  @override
  String get popularCategories => 'Popular categories';

  @override
  String get trendingToday => 'Trending today';

  @override
  String get retry => 'Retry';

  @override
  String get noTrendingBooks => 'No trending books available right now.';

  @override
  String get categoryFiction => 'Fiction';

  @override
  String get categoryScience => 'Science';

  @override
  String get categoryHistory => 'History';

  @override
  String get categoryRomance => 'Romance';

  @override
  String get categoryFantasy => 'Fantasy';

  @override
  String get categoryMystery => 'Mystery';

  @override
  String get categoryBiography => 'Biography';

  @override
  String get categoryChildren => 'Children';

  @override
  String get myLibrary => 'My Library';

  @override
  String libraryError(String message) {
    return 'Error: $message';
  }

  @override
  String libraryEmptyTab(String status) {
    return 'No books in \"$status\".';
  }

  @override
  String get statusReading => 'Reading';

  @override
  String get statusRead => 'Read';

  @override
  String get statusWantToRead => 'Want to read';

  @override
  String get profile => 'Profile';

  @override
  String get signOut => 'Sign out';

  @override
  String get gallery => 'Gallery';

  @override
  String get camera => 'Camera';

  @override
  String get statistics => 'Statistics';

  @override
  String get booksRead => 'Books read';

  @override
  String get averageRating => 'Average rating';

  @override
  String get favoriteGenre => 'Favorite genre';

  @override
  String get genreVarious => 'Various';

  @override
  String get notAvailable => '—';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get toggleTheme => 'Toggle theme';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageUkrainian => 'Ukrainian';

  @override
  String get languagePolish => 'Polish';

  @override
  String get viewDetails => 'View details';

  @override
  String get delete => 'Delete';

  @override
  String ratingOutOfTen(int rating) {
    return 'Rating: $rating/10';
  }

  @override
  String pageNumber(int page) {
    return 'Page $page';
  }

  @override
  String readingProgressDeterminate(int current, int total, int percent) {
    return 'Page $current of $total ($percent%)';
  }

  @override
  String readingProgressUnknownTotal(int current) {
    return 'Page $current — total pages unknown';
  }

  @override
  String get addToLibrary => 'Add to library';

  @override
  String get editLibraryEntry => 'Edit library entry';

  @override
  String get addToLibrarySheet => 'Add to library';

  @override
  String get statusLabel => 'Status';

  @override
  String get ratingLabel => 'Rating (1-10)';

  @override
  String get currentPageLabel => 'Current page';

  @override
  String get totalPagesLabel => 'Total pages (optional)';

  @override
  String get reviewLabel => 'Review';

  @override
  String get save => 'Save';

  @override
  String get validationRating => 'Enter a rating from 1 to 10.';

  @override
  String get validationPage => 'Enter a valid page number.';

  @override
  String validationCurrentExceedsTotal(int total) {
    return 'Current page cannot exceed $total total pages.';
  }

  @override
  String validationTotalBelowCurrent(int current) {
    return 'Total pages must be at least $current (current page).';
  }

  @override
  String get validationTotalPages => 'Enter a valid total page count.';

  @override
  String get bookDetails => 'Book Details';

  @override
  String get author => 'Author';

  @override
  String get published => 'Published';

  @override
  String get pages => 'Pages';

  @override
  String get description => 'Description';

  @override
  String get subjects => 'Subjects';

  @override
  String get unknownAuthor => 'Unknown author';

  @override
  String searchResultsTitle(String query) {
    return 'Results: \"$query\"';
  }

  @override
  String searchCategoryTitle(String name) {
    return 'Category: $name';
  }

  @override
  String get noSearchResults => 'No books found for this query.';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get createAccount => 'Create account';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign in';

  @override
  String get createAccountPrompt => 'Create an account';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get resetPasswordInstructions =>
      'Enter your email and we will send you a reset link.';

  @override
  String get sendResetLink => 'Send reset link';

  @override
  String get backToSignIn => 'Back to Sign In';

  @override
  String get resetEmailSent => 'Check your inbox for a password reset link.';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get validationEmail => 'Enter a valid email.';

  @override
  String get validationPassword => 'Enter your password.';

  @override
  String get validationPasswordMin => 'Use at least 6 characters.';

  @override
  String get validationConfirmPassword => 'Passwords do not match.';

  @override
  String firstPublished(int year) {
    return 'First published: $year';
  }

  @override
  String get authInvalidEmail => 'Invalid email address.';

  @override
  String get authUserDisabled => 'This account has been disabled.';

  @override
  String get authUserNotFound => 'No account found for this email.';

  @override
  String get authWrongPassword => 'Incorrect password.';

  @override
  String get authEmailInUse => 'An account already exists for this email.';

  @override
  String get authWeakPassword =>
      'Password is too weak. Use at least 6 characters.';

  @override
  String get authInvalidCredential => 'Invalid email or password.';

  @override
  String get authTooManyRequests => 'Too many attempts. Try again later.';

  @override
  String get authFailed => 'Authentication failed.';

  @override
  String get storagePhotoNotFound =>
      'Profile photo not found in storage. Please ensure Firebase Storage is enabled in the Firebase Console.';

  @override
  String get searchQueryEmpty => 'Search query is empty.';
}
