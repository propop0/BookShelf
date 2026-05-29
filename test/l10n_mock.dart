import 'package:bookshelf/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class MockAppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const MockAppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async => MockAppLocalizations();

  @override
  bool shouldReload(MockAppLocalizationsDelegate old) => false;
}

class MockAppLocalizations extends AppLocalizations {
  MockAppLocalizations() : super('en');

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
  String get searchHint => 'Hint';
  @override
  String get searchFieldLabel => 'Search';
  @override
  String get searchButton => 'Search';
  @override
  String get searchValidationEmpty => 'Empty';
  @override
  String get searchValidationMinLength => 'Short';
  @override
  String get popularCategories => 'Categories';
  @override
  String get trendingToday => 'Trending';
  @override
  String get retry => 'Retry';
  @override
  String get noTrendingBooks => 'No trending';
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
  String get myLibrary => 'Library';
  @override
  String libraryError(String message) => 'Error: $message';
  @override
  String libraryEmptyTab(String status) => 'Empty $status';
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
  String get averageRating => 'Avg rating';
  @override
  String get favoriteGenre => 'Fav genre';
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
  String get viewDetails => 'Details';
  @override
  String get delete => 'Delete';
  @override
  String ratingOutOfTen(int rating) => 'Rating: $rating/10';
  @override
  String pageNumber(int page) => 'Page $page';
  @override
  String readingProgressDeterminate(int current, int total, int percent) => 'Page $current of $total ($percent%)';
  @override
  String readingProgressUnknownTotal(int current) => 'Page $current — unknown';
  @override
  String get addToLibrary => 'Add';
  @override
  String get editLibraryEntry => 'Edit';
  @override
  String get addToLibrarySheet => 'Add to library';
  @override
  String get statusLabel => 'Status';
  @override
  String get ratingLabel => 'Rating';
  @override
  String get currentPageLabel => 'Current page';
  @override
  String get totalPagesLabel => 'Total pages';
  @override
  String get reviewLabel => 'Review';
  @override
  String get save => 'Save';
  @override
  String get validationRating => 'Invalid rating';
  @override
  String get validationPage => 'Invalid page';
  @override
  String validationCurrentExceedsTotal(int total) => 'Current page exceeds $total';
  @override
  String validationTotalBelowCurrent(int current) => 'Total below $current';
  @override
  String get validationTotalPages => 'Invalid total';
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
  String searchResultsTitle(String query) => 'Results: $query';
  @override
  String searchCategoryTitle(String name) => 'Category: $name';
  @override
  String get noSearchResults => 'No results';
  @override
  String get signIn => 'Sign In';
  @override
  String get signUp => 'Sign Up';
  @override
  String get email => 'Email';
  @override
  String get password => 'Password';
  @override
  String get confirmPassword => 'Confirm';
  @override
  String get forgotPassword => 'Forgot?';
  @override
  String get createAccount => 'Create';
  @override
  String get alreadyHaveAccount => 'Have account?';
  @override
  String get createAccountPrompt => 'Create account';
  @override
  String get resetPassword => 'Reset';
  @override
  String get resetPasswordInstructions => 'Instructions';
  @override
  String get sendResetLink => 'Send';
  @override
  String get backToSignIn => 'Back';
  @override
  String get resetEmailSent => 'Sent';
  @override
  String get welcomeBack => 'Welcome';
  @override
  String get validationEmail => 'Invalid email';
  @override
  String get validationPassword => 'Invalid password';
  @override
  String get validationPasswordMin => 'Too short';
  @override
  String get validationConfirmPassword => 'Mismatch';
  @override
  String firstPublished(int year) => 'First published: $year';
  @override
  String get authInvalidEmail => 'Invalid email';
  @override
  String get authUserDisabled => 'Disabled';
  @override
  String get authUserNotFound => 'Not found';
  @override
  String get authWrongPassword => 'Wrong password';
  @override
  String get authEmailInUse => 'Email in use';
  @override
  String get authWeakPassword => 'Weak password';
  @override
  String get authInvalidCredential => 'Invalid';
  @override
  String get authTooManyRequests => 'Too many';
  @override
  String get authFailed => 'Failed';
  @override
  String get storagePhotoNotFound => 'Not found';
  @override
  String get searchQueryEmpty => 'Empty';
}
