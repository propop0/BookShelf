// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'BookShelf';

  @override
  String get navHome => 'Główna';

  @override
  String get navLibrary => 'Biblioteka';

  @override
  String get navProfile => 'Profil';

  @override
  String get searchBooks => 'Szukaj książek';

  @override
  String get searchHint => 'np. Harry Potter';

  @override
  String get searchFieldLabel => 'Tytuł lub autor';

  @override
  String get searchButton => 'Szukaj';

  @override
  String get searchValidationEmpty => 'Wpisz zapytanie wyszukiwania.';

  @override
  String get searchValidationMinLength => 'Użyj co najmniej 2 znaków.';

  @override
  String get popularCategories => 'Popularne kategorie';

  @override
  String get trendingToday => 'Dzisiaj w trendach';

  @override
  String get retry => 'Ponów';

  @override
  String get noTrendingBooks => 'Brak trendujących książek.';

  @override
  String get categoryFiction => 'Literatura piękna';

  @override
  String get categoryScience => 'Nauka';

  @override
  String get categoryHistory => 'Historia';

  @override
  String get categoryRomance => 'Romans';

  @override
  String get categoryFantasy => 'Fantastyka';

  @override
  String get categoryMystery => 'Kryminał';

  @override
  String get categoryBiography => 'Biografia';

  @override
  String get categoryChildren => 'Dla dzieci';

  @override
  String get myLibrary => 'Moja biblioteka';

  @override
  String libraryError(String message) {
    return 'Błąd: $message';
  }

  @override
  String libraryEmptyTab(String status) {
    return 'Brak książek w „$status”.';
  }

  @override
  String get statusReading => 'Czytam';

  @override
  String get statusRead => 'Przeczytane';

  @override
  String get statusWantToRead => 'Chcę przeczytać';

  @override
  String get profile => 'Profil';

  @override
  String get signOut => 'Wyloguj';

  @override
  String get gallery => 'Galeria';

  @override
  String get camera => 'Aparat';

  @override
  String get statistics => 'Statystyki';

  @override
  String get booksRead => 'Przeczytane książki';

  @override
  String get averageRating => 'Średnia ocena';

  @override
  String get favoriteGenre => 'Ulubiony gatunek';

  @override
  String get genreVarious => 'Różne';

  @override
  String get notAvailable => '—';

  @override
  String get settings => 'Ustawienia';

  @override
  String get theme => 'Motyw';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get themeSystem => 'Systemowy';

  @override
  String get toggleTheme => 'Zmień motyw';

  @override
  String get language => 'Język';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageUkrainian => 'Українська';

  @override
  String get languagePolish => 'Polski';

  @override
  String get viewDetails => 'Szczegóły';

  @override
  String get delete => 'Usuń';

  @override
  String ratingOutOfTen(int rating) {
    return 'Ocena: $rating/10';
  }

  @override
  String pageNumber(int page) {
    return 'Strona $page';
  }

  @override
  String readingProgressDeterminate(int current, int total, int percent) {
    return 'Strona $current z $total ($percent%)';
  }

  @override
  String readingProgressUnknownTotal(int current) {
    return 'Strona $current — liczba stron nieznana';
  }

  @override
  String get addToLibrary => 'Dodaj do biblioteki';

  @override
  String get editLibraryEntry => 'Edytuj wpis';

  @override
  String get addToLibrarySheet => 'Dodaj do biblioteki';

  @override
  String get statusLabel => 'Status';

  @override
  String get ratingLabel => 'Ocena (1–10)';

  @override
  String get currentPageLabel => 'Aktualna strona';

  @override
  String get totalPagesLabel => 'Liczba stron (opcjonalnie)';

  @override
  String get reviewLabel => 'Recenzja';

  @override
  String get save => 'Zapisz';

  @override
  String get validationRating => 'Wpisz ocenę od 1 do 10.';

  @override
  String get validationPage => 'Wpisz prawidłowy numer strony.';

  @override
  String validationCurrentExceedsTotal(int total) {
    return 'Aktualna strona nie może przekraczać $total.';
  }

  @override
  String validationTotalBelowCurrent(int current) {
    return 'Liczba stron musi być co najmniej $current.';
  }

  @override
  String get validationTotalPages => 'Wpisz prawidłową liczbę stron.';

  @override
  String get bookDetails => 'Szczegóły książki';

  @override
  String get author => 'Autor';

  @override
  String get published => 'Wydano';

  @override
  String get pages => 'Strony';

  @override
  String get description => 'Opis';

  @override
  String get subjects => 'Tematy';

  @override
  String get unknownAuthor => 'Nieznany autor';

  @override
  String searchResultsTitle(String query) {
    return 'Wyniki: „$query”';
  }

  @override
  String searchCategoryTitle(String name) {
    return 'Kategoria: $name';
  }

  @override
  String get noSearchResults => 'Nie znaleziono książek dla tego zapytania.';

  @override
  String get signIn => 'Zaloguj się';

  @override
  String get signUp => 'Rejestracja';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Hasło';

  @override
  String get confirmPassword => 'Potwierdź hasło';

  @override
  String get forgotPassword => 'Zapomniałeś hasła?';

  @override
  String get createAccount => 'Utwórz konto';

  @override
  String get alreadyHaveAccount => 'Masz już konto? Zaloguj się';

  @override
  String get createAccountPrompt => 'Utwórz konto';

  @override
  String get resetPassword => 'Reset hasła';

  @override
  String get resetPasswordInstructions =>
      'Podaj e-mail — wyślemy link do resetu hasła.';

  @override
  String get sendResetLink => 'Wyślij link';

  @override
  String get backToSignIn => 'Wróć do logowania';

  @override
  String get resetEmailSent =>
      'Sprawdź skrzynkę — wysłano link do resetu hasła.';

  @override
  String get welcomeBack => 'Witaj ponownie';

  @override
  String get validationEmail => 'Wpisz prawidłowy e-mail.';

  @override
  String get validationPassword => 'Wpisz hasło.';

  @override
  String get validationPasswordMin => 'Co najmniej 6 znaków.';

  @override
  String get validationConfirmPassword => 'Hasła nie są zgodne.';

  @override
  String firstPublished(int year) {
    return 'Pierwsze wydanie: $year';
  }

  @override
  String get authInvalidEmail => 'Nieprawidłowy adres e-mail.';

  @override
  String get authUserDisabled => 'To konto zostało wyłączone.';

  @override
  String get authUserNotFound => 'Nie znaleziono konta dla tego e-maila.';

  @override
  String get authWrongPassword => 'Nieprawidłowe hasło.';

  @override
  String get authEmailInUse => 'Konto z tym e-mailem już istnieje.';

  @override
  String get authWeakPassword =>
      'Hasło jest za słabe. Użyj co najmniej 6 znaków.';

  @override
  String get authInvalidCredential => 'Nieprawidłowy e-mail lub hasło.';

  @override
  String get authTooManyRequests => 'Zbyt wiele prób. Spróbuj później.';

  @override
  String get authFailed => 'Uwierzytelnianie nie powiodło się.';

  @override
  String get storagePhotoNotFound =>
      'Nie znaleziono zdjęcia profilowego. Sprawdź Firebase Storage.';

  @override
  String get searchQueryEmpty => 'Zapytanie jest puste.';
}
