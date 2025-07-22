import 'package:dartz/dartz.dart';
import 'package:gowithride/core/errors/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) throw FormatException();
      return Right(integer);
    } on FormatException {
      return Left(InputFailure('Invalid input: Must be a positive integer'));
    }
  }

  Either<Failure, double> stringToPositiveDouble(String str) {
    try {
      final value = double.parse(str);
      if (value <= 0) throw FormatException();
      return Right(value);
    } on FormatException {
      return Left(InputFailure('Invalid input: Must be a positive number'));
    }
  }
}