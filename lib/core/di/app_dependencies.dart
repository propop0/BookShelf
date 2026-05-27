import '../../features/book_catalog/data/datasources/open_library_remote_data_source.dart';
import '../../features/book_catalog/data/repositories/book_repository_impl.dart';
import '../../features/book_catalog/domain/repositories/book_repository.dart';
import '../../features/book_catalog/domain/usecases/get_book_details_use_case.dart';
import '../../features/book_catalog/domain/usecases/search_books_use_case.dart';
import '../network/api_client.dart';

class AppDependencies {
  const AppDependencies._();

  static final ApiClient _apiClient = ApiClient();
  static final OpenLibraryRemoteDataSource _remoteDataSource =
      OpenLibraryRemoteDataSource(_apiClient);
  static final BookRepository _bookRepository = BookRepositoryImpl(
    _remoteDataSource,
  );

  static final SearchBooksUseCase searchBooksUseCase = SearchBooksUseCase(
    _bookRepository,
  );
  static final GetBookDetailsUseCase getBookDetailsUseCase =
      GetBookDetailsUseCase(_bookRepository);
}
