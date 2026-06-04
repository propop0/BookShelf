// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'BookShelf';

  @override
  String get navHome => 'Головна';

  @override
  String get navLibrary => 'Бібліотека';

  @override
  String get navProfile => 'Профіль';

  @override
  String get searchBooks => 'Пошук книг';

  @override
  String get searchHint => 'напр. Гаррі Поттер';

  @override
  String get searchFieldLabel => 'Назва або автор';

  @override
  String get searchButton => 'Шукати';

  @override
  String get searchValidationEmpty => 'Введіть пошуковий запит.';

  @override
  String get searchValidationMinLength => 'Використайте щонайменше 2 символи.';

  @override
  String get popularCategories => 'Популярні категорії';

  @override
  String get trendingToday => 'У тренді сьогодні';

  @override
  String get retry => 'Повторити';

  @override
  String get noTrendingBooks => 'Зараз немає книг у тренді.';

  @override
  String get categoryFiction => 'Художня література';

  @override
  String get categoryScience => 'Наука';

  @override
  String get categoryHistory => 'Історія';

  @override
  String get categoryRomance => 'Романтика';

  @override
  String get categoryFantasy => 'Фентезі';

  @override
  String get categoryMystery => 'Детектив';

  @override
  String get categoryBiography => 'Біографія';

  @override
  String get categoryChildren => 'Дитяча';

  @override
  String get myLibrary => 'Моя бібліотека';

  @override
  String libraryError(String message) {
    return 'Помилка: $message';
  }

  @override
  String libraryEmptyTab(String status) {
    return 'Немає книг у «$status».';
  }

  @override
  String get statusReading => 'Читаю';

  @override
  String get statusRead => 'Прочитано';

  @override
  String get statusWantToRead => 'Хочу прочитати';

  @override
  String get profile => 'Профіль';

  @override
  String get signOut => 'Вийти';

  @override
  String get gallery => 'Галерея';

  @override
  String get camera => 'Камера';

  @override
  String get statistics => 'Статистика';

  @override
  String get booksRead => 'Прочитано книг';

  @override
  String get averageRating => 'Середня оцінка';

  @override
  String get favoriteGenre => 'Улюблений жанр';

  @override
  String get genreVarious => 'Різне';

  @override
  String get notAvailable => '—';

  @override
  String get settings => 'Налаштування';

  @override
  String get theme => 'Тема';

  @override
  String get themeLight => 'Світла';

  @override
  String get themeDark => 'Темна';

  @override
  String get themeSystem => 'Системна';

  @override
  String get toggleTheme => 'Змінити тему';

  @override
  String get language => 'Мова';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageUkrainian => 'Українська';

  @override
  String get languagePolish => 'Polski';

  @override
  String get viewDetails => 'Деталі';

  @override
  String get delete => 'Видалити';

  @override
  String ratingOutOfTen(int rating) {
    return 'Оцінка: $rating/10';
  }

  @override
  String pageNumber(int page) {
    return 'Сторінка $page';
  }

  @override
  String readingProgressDeterminate(int current, int total, int percent) {
    return 'Сторінка $current з $total ($percent%)';
  }

  @override
  String readingProgressUnknownTotal(int current) {
    return 'Сторінка $current — загальна кількість невідома';
  }

  @override
  String get addToLibrary => 'Додати до бібліотеки';

  @override
  String get editLibraryEntry => 'Редагувати запис';

  @override
  String get addToLibrarySheet => 'Додати до бібліотеки';

  @override
  String get statusLabel => 'Статус';

  @override
  String get ratingLabel => 'Оцінка (1–10)';

  @override
  String get currentPageLabel => 'Поточна сторінка';

  @override
  String get totalPagesLabel => 'Усього сторінок (необовʼязково)';

  @override
  String get reviewLabel => 'Рецензія';

  @override
  String get save => 'Зберегти';

  @override
  String get validationRating => 'Введіть оцінку від 1 до 10.';

  @override
  String get validationPage => 'Введіть коректний номер сторінки.';

  @override
  String validationCurrentExceedsTotal(int total) {
    return 'Поточна сторінка не може перевищувати $total.';
  }

  @override
  String validationTotalBelowCurrent(int current) {
    return 'Загальна кількість має бути не менше $current.';
  }

  @override
  String get validationTotalPages => 'Введіть коректну кількість сторінок.';

  @override
  String get bookDetails => 'Деталі книги';

  @override
  String get author => 'Автор';

  @override
  String get published => 'Видано';

  @override
  String get pages => 'Сторінки';

  @override
  String get description => 'Опис';

  @override
  String get subjects => 'Теми';

  @override
  String get unknownAuthor => 'Невідомий автор';

  @override
  String searchResultsTitle(String query) {
    return 'Результати: «$query»';
  }

  @override
  String searchCategoryTitle(String name) {
    return 'Категорія: $name';
  }

  @override
  String get noSearchResults => 'Книг за цим запитом не знайдено.';

  @override
  String get signIn => 'Увійти';

  @override
  String get signUp => 'Реєстрація';

  @override
  String get email => 'Електронна пошта';

  @override
  String get password => 'Пароль';

  @override
  String get confirmPassword => 'Підтвердіть пароль';

  @override
  String get forgotPassword => 'Забули пароль?';

  @override
  String get createAccount => 'Створити обліковий запис';

  @override
  String get alreadyHaveAccount => 'Вже є обліковий запис? Увійти';

  @override
  String get createAccountPrompt => 'Створити обліковий запис';

  @override
  String get resetPassword => 'Скидання пароля';

  @override
  String get resetPasswordInstructions =>
      'Введіть email — ми надішлемо посилання для скидання.';

  @override
  String get sendResetLink => 'Надіслати посилання';

  @override
  String get backToSignIn => 'Назад до входу';

  @override
  String get resetEmailSent =>
      'Перевірте пошту — надіслано посилання для скидання.';

  @override
  String get welcomeBack => 'З поверненням';

  @override
  String get signInWithGoogle => 'Увійти через Google';

  @override
  String get addManually => 'Додати вручну';

  @override
  String get addBookManuallyTitle => 'Додати книгу вручну';

  @override
  String get titleLabel => 'Назва';

  @override
  String get authorsLabel => 'Автор(и)';

  @override
  String get pagesLabel => 'Кількість сторінок (необов\'язково)';

  @override
  String get addBookButton => 'Додати книгу';

  @override
  String get validationEmail => 'Введіть коректний email.';

  @override
  String get validationPassword => 'Введіть пароль.';

  @override
  String get validationPasswordMin => 'Щонайменше 6 символів.';

  @override
  String get validationConfirmPassword => 'Паролі не збігаються.';

  @override
  String firstPublished(int year) {
    return 'Перше видання: $year';
  }

  @override
  String get authInvalidEmail => 'Некоректна адреса email.';

  @override
  String get authUserDisabled => 'Цей обліковий запис вимкнено.';

  @override
  String get authUserNotFound => 'Обліковий запис з таким email не знайдено.';

  @override
  String get authWrongPassword => 'Невірний пароль.';

  @override
  String get authEmailInUse => 'Обліковий запис з цим email вже існує.';

  @override
  String get authWeakPassword => 'Занадто слабкий пароль. Мінімум 6 символів.';

  @override
  String get authInvalidCredential => 'Невірний email або пароль.';

  @override
  String get authTooManyRequests => 'Забагато спроб. Спробуйте пізніше.';

  @override
  String get authFailed => 'Помилка автентифікації.';

  @override
  String get storagePhotoNotFound =>
      'Фото профілю не знайдено. Перевірте Firebase Storage у консолі.';

  @override
  String get searchQueryEmpty => 'Пошуковий запит порожній.';
}
