class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error. Please try again.']);
}

class ServerException extends AppException {
  const ServerException([super.message = 'Server error. Please try later.']);
}

class ParsingException extends AppException {
  const ParsingException([super.message = 'Failed to parse server response.']);
}
