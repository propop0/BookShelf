import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl'),
    Locale('uk'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'BookShelf'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @searchBooks.
  ///
  /// In en, this message translates to:
  /// **'Search books'**
  String get searchBooks;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Harry Potter'**
  String get searchHint;

  /// No description provided for @searchFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Title or author'**
  String get searchFieldLabel;

  /// No description provided for @searchButton.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchButton;

  /// No description provided for @searchValidationEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a search query.'**
  String get searchValidationEmpty;

  /// No description provided for @searchValidationMinLength.
  ///
  /// In en, this message translates to:
  /// **'Use at least 2 characters.'**
  String get searchValidationMinLength;

  /// No description provided for @popularCategories.
  ///
  /// In en, this message translates to:
  /// **'Popular categories'**
  String get popularCategories;

  /// No description provided for @trendingToday.
  ///
  /// In en, this message translates to:
  /// **'Trending today'**
  String get trendingToday;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noTrendingBooks.
  ///
  /// In en, this message translates to:
  /// **'No trending books available right now.'**
  String get noTrendingBooks;

  /// No description provided for @categoryFiction.
  ///
  /// In en, this message translates to:
  /// **'Fiction'**
  String get categoryFiction;

  /// No description provided for @categoryScience.
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get categoryScience;

  /// No description provided for @categoryHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get categoryHistory;

  /// No description provided for @categoryRomance.
  ///
  /// In en, this message translates to:
  /// **'Romance'**
  String get categoryRomance;

  /// No description provided for @categoryFantasy.
  ///
  /// In en, this message translates to:
  /// **'Fantasy'**
  String get categoryFantasy;

  /// No description provided for @categoryMystery.
  ///
  /// In en, this message translates to:
  /// **'Mystery'**
  String get categoryMystery;

  /// No description provided for @categoryBiography.
  ///
  /// In en, this message translates to:
  /// **'Biography'**
  String get categoryBiography;

  /// No description provided for @categoryChildren.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get categoryChildren;

  /// No description provided for @myLibrary.
  ///
  /// In en, this message translates to:
  /// **'My Library'**
  String get myLibrary;

  /// No description provided for @libraryError.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String libraryError(String message);

  /// No description provided for @libraryEmptyTab.
  ///
  /// In en, this message translates to:
  /// **'No books in \"{status}\".'**
  String libraryEmptyTab(String status);

  /// No description provided for @statusReading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get statusReading;

  /// No description provided for @statusRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get statusRead;

  /// No description provided for @statusWantToRead.
  ///
  /// In en, this message translates to:
  /// **'Want to read'**
  String get statusWantToRead;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @booksRead.
  ///
  /// In en, this message translates to:
  /// **'Books read'**
  String get booksRead;

  /// No description provided for @averageRating.
  ///
  /// In en, this message translates to:
  /// **'Average rating'**
  String get averageRating;

  /// No description provided for @favoriteGenre.
  ///
  /// In en, this message translates to:
  /// **'Favorite genre'**
  String get favoriteGenre;

  /// No description provided for @genreVarious.
  ///
  /// In en, this message translates to:
  /// **'Various'**
  String get genreVarious;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get notAvailable;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @toggleTheme.
  ///
  /// In en, this message translates to:
  /// **'Toggle theme'**
  String get toggleTheme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageUkrainian.
  ///
  /// In en, this message translates to:
  /// **'Ukrainian'**
  String get languageUkrainian;

  /// No description provided for @languagePolish.
  ///
  /// In en, this message translates to:
  /// **'Polish'**
  String get languagePolish;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get viewDetails;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @ratingOutOfTen.
  ///
  /// In en, this message translates to:
  /// **'Rating: {rating}/10'**
  String ratingOutOfTen(int rating);

  /// No description provided for @pageNumber.
  ///
  /// In en, this message translates to:
  /// **'Page {page}'**
  String pageNumber(int page);

  /// No description provided for @readingProgressDeterminate.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total} ({percent}%)'**
  String readingProgressDeterminate(int current, int total, int percent);

  /// No description provided for @readingProgressUnknownTotal.
  ///
  /// In en, this message translates to:
  /// **'Page {current} — total pages unknown'**
  String readingProgressUnknownTotal(int current);

  /// No description provided for @addToLibrary.
  ///
  /// In en, this message translates to:
  /// **'Add to library'**
  String get addToLibrary;

  /// No description provided for @editLibraryEntry.
  ///
  /// In en, this message translates to:
  /// **'Edit library entry'**
  String get editLibraryEntry;

  /// No description provided for @addToLibrarySheet.
  ///
  /// In en, this message translates to:
  /// **'Add to library'**
  String get addToLibrarySheet;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @ratingLabel.
  ///
  /// In en, this message translates to:
  /// **'Rating (1-10)'**
  String get ratingLabel;

  /// No description provided for @currentPageLabel.
  ///
  /// In en, this message translates to:
  /// **'Current page'**
  String get currentPageLabel;

  /// No description provided for @totalPagesLabel.
  ///
  /// In en, this message translates to:
  /// **'Total pages (optional)'**
  String get totalPagesLabel;

  /// No description provided for @reviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewLabel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @validationRating.
  ///
  /// In en, this message translates to:
  /// **'Enter a rating from 1 to 10.'**
  String get validationRating;

  /// No description provided for @validationPage.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid page number.'**
  String get validationPage;

  /// No description provided for @validationCurrentExceedsTotal.
  ///
  /// In en, this message translates to:
  /// **'Current page cannot exceed {total} total pages.'**
  String validationCurrentExceedsTotal(int total);

  /// No description provided for @validationTotalBelowCurrent.
  ///
  /// In en, this message translates to:
  /// **'Total pages must be at least {current} (current page).'**
  String validationTotalBelowCurrent(int current);

  /// No description provided for @validationTotalPages.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid total page count.'**
  String get validationTotalPages;

  /// No description provided for @bookDetails.
  ///
  /// In en, this message translates to:
  /// **'Book Details'**
  String get bookDetails;

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// No description provided for @published.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get published;

  /// No description provided for @pages.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get pages;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @subjects.
  ///
  /// In en, this message translates to:
  /// **'Subjects'**
  String get subjects;

  /// No description provided for @unknownAuthor.
  ///
  /// In en, this message translates to:
  /// **'Unknown author'**
  String get unknownAuthor;

  /// No description provided for @searchResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Results: \"{query}\"'**
  String searchResultsTitle(String query);

  /// No description provided for @searchCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Category: {name}'**
  String searchCategoryTitle(String name);

  /// No description provided for @noSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No books found for this query.'**
  String get noSearchResults;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get alreadyHaveAccount;

  /// No description provided for @createAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccountPrompt;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @resetPasswordInstructions.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we will send you a reset link.'**
  String get resetPasswordInstructions;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get sendResetLink;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get backToSignIn;

  /// No description provided for @resetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Check your inbox for a password reset link.'**
  String get resetEmailSent;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @addManually.
  ///
  /// In en, this message translates to:
  /// **'Add manually'**
  String get addManually;

  /// No description provided for @addBookManuallyTitle.
  ///
  /// In en, this message translates to:
  /// **'Add book manually'**
  String get addBookManuallyTitle;

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleLabel;

  /// No description provided for @authorsLabel.
  ///
  /// In en, this message translates to:
  /// **'Author(s)'**
  String get authorsLabel;

  /// No description provided for @pagesLabel.
  ///
  /// In en, this message translates to:
  /// **'Total pages (optional)'**
  String get pagesLabel;

  /// No description provided for @addBookButton.
  ///
  /// In en, this message translates to:
  /// **'Add Book'**
  String get addBookButton;

  /// No description provided for @validationEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email.'**
  String get validationEmail;

  /// No description provided for @validationPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get validationPassword;

  /// No description provided for @validationPasswordMin.
  ///
  /// In en, this message translates to:
  /// **'Use at least 6 characters.'**
  String get validationPasswordMin;

  /// No description provided for @validationConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get validationConfirmPassword;

  /// No description provided for @firstPublished.
  ///
  /// In en, this message translates to:
  /// **'First published: {year}'**
  String firstPublished(int year);

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address.'**
  String get authInvalidEmail;

  /// No description provided for @authUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled.'**
  String get authUserDisabled;

  /// No description provided for @authUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found for this email.'**
  String get authUserNotFound;

  /// No description provided for @authWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password.'**
  String get authWrongPassword;

  /// No description provided for @authEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account already exists for this email.'**
  String get authEmailInUse;

  /// No description provided for @authWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak. Use at least 6 characters.'**
  String get authWeakPassword;

  /// No description provided for @authInvalidCredential.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get authInvalidCredential;

  /// No description provided for @authTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later.'**
  String get authTooManyRequests;

  /// No description provided for @authFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed.'**
  String get authFailed;

  /// No description provided for @storagePhotoNotFound.
  ///
  /// In en, this message translates to:
  /// **'Profile photo not found in storage. Please ensure Firebase Storage is enabled in the Firebase Console.'**
  String get storagePhotoNotFound;

  /// No description provided for @searchQueryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Search query is empty.'**
  String get searchQueryEmpty;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pl', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
