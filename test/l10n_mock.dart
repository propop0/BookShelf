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
  String get searchBooks => 'Search books';
  @override
  String get unknownAuthor => 'Unknown author';
  @override
  String firstPublished(int year) => 'First published: $year';
  @override
  String get searchFieldLabel => 'Search';
  @override
  String get searchHint => 'Hint';
  @override
  String get searchButton => 'Search';
  @override
  String get popularCategories => 'Categories';
  @override
  String get trendingToday => 'Trending';
  @override
  String get myLibrary => 'Library';
  @override
  String get profile => 'Profile';
  @override
  String get settings => 'Settings';
  @override
  String get theme => 'Theme';
  @override
  String get dark => 'Dark';
  @override
  String get light => 'Light';
  @override
  String get system => 'System';
  @override
  String get logout => 'Logout';
  @override
  String get login => 'Login';
  @override
  String get register => 'Register';
  @override
  String get email => 'Email';
  @override
  String get password => 'Password';
  @override
  String get forgotPassword => 'Forgot password';
  @override
  String get resetPassword => 'Reset password';
  @override
  String get signUp => 'Sign Up';
  @override
  String get signIn => 'Sign In';
  @override
  String get dontHaveAccount => 'No account?';
  @override
  String get alreadyHaveAccount => 'Have account?';
  @override
  String get bookDetails => 'Book Details';
  @override
  String get addToLibrary => 'Add';
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
  String get retry => 'Retry';
  @override
  String get noTrendingBooks => 'No trending';
  @override
  String get noSearchResults => 'No results';
  @override
  String get searchValidationEmpty => 'Empty';
  @override
  String get searchValidationMinLength => 'Short';
  @override
  String libraryError(String error) => 'Error: $error';
  @override
  String libraryEmptyTab(String status) => 'Empty $status';
  @override
  String ratingOutOfTen(int rating) => 'Rating: $rating/10';
  @override
  String pageNumber(int page) => 'Page: $page';
  @override
  String get viewDetails => 'Details';
  @override
  String get delete => 'Delete';
  @override
  String get reading => 'Reading';
  @override
  String get read => 'Read';
  @override
  String get wantToRead => 'Want to read';
  @override
  String get notAvailable => 'N/A';
  @override
  String get statistics => 'Statistics';
  @override
  String get booksRead => 'Books read';
  @override
  String get averageRating => 'Avg rating';
  @override
  String get favoriteGenre => 'Fav genre';
  @override
  String get language => 'Language';
  @override
  String get english => 'English';
  @override
  String get ukrainian => 'Ukrainian';
  @override
  String get polish => 'Polish';
  @override
  String get loginError => 'Login error';
  @override
  String get registerError => 'Register error';
  @override
  String get passwordResetSent => 'Sent';
  @override
  String get update => 'Update';
  @override
  String get cancel => 'Cancel';
  @override
  String get editEntry => 'Edit';
  @override
  String get status => 'Status';
  @override
  String get rating => 'Rating';
  @override
  String get currentPage => 'Current page';
  @override
  String get review => 'Review';
  @override
  String get writeReviewHint => 'Write review...';
  @override
  String get invalidEmail => 'Invalid email';
  @override
  String get invalidPassword => 'Invalid password';
  @override
  String get passwordsDoNotMatch => 'Mismatch';
  @override
  String get pleaseSignIn => 'Sign in';
  @override
  String get various => 'Various';
  @override
  String get progressPercentage(int percent) => '$percent%';
  @override
  String get progressPages(int current, int total) => '$current / $total';
}
