abstract class Failure {
  final String message;
  final int? code;

  Failure(this.message, [this.code]);
}

class ServerFailure extends Failure {
  ServerFailure(String message, [int? code]) : super(message, code);
}

class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure(String message) : super(message);
}

class InputFailure extends Failure {
  InputFailure(String message) : super(message);
}