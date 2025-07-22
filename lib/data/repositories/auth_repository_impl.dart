import 'package:dartz/dartz.dart';
import 'package:gowithride/core/errors/exceptions.dart'; // Import custom exceptions
import 'package:gowithride/core/errors/failures.dart';
import 'package:gowithride/data/datasources/local_data_source.dart';
import 'package:gowithride/data/datasources/remote_data_source.dart';
import 'package:gowithride/data/models/user_model.dart'; // Import UserModel
import 'package:gowithride/domain/entities/user.dart';
import 'package:gowithride/domain/repositories/auth_repository.dart';
// Import NetworkInfo if you plan to use it for network checks
// import 'package:gowithride/core/network/network_info.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  // final NetworkInfo networkInfo; // Optional: for checking internet connection

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    // required this.networkInfo, // Optional
  });

  // Helper function to handle common try-catch logic for API calls
  Future<Either<Failure, T>> _tryCatch<T>(Future<T> Function() action) async {
    // Example: Check network connectivity before proceeding
    // if (await networkInfo.isConnected == false) {
    //   return Left(NetworkFailure("No internet connection."));
    // }
    try {
      final result = await action();
      return Right(result);
    } on ServerException catch (e) {
      // Assuming ServerException has a message and an optional code
      // Your ServerFailure constructor takes (message, [code])
      return Left(ServerFailure(e.toString())); // Pass the full exception message, or refine
    } on AuthenticationException catch (e) {
      return Left(ServerFailure(e.toString())); // Or create an AuthFailure
    } on ClientException catch (e) {
      return Left(ServerFailure(e.toString())); // Or create a specific ClientFailure
    } on CacheException catch (e) {
      return Left(CacheFailure(e.toString()));
    } on NoInternetException catch (e) {
      return Left(NetworkFailure(e.toString()));
    } catch (e) {
      // Catch-all for other unexpected errors
      print("AuthRepositoryImpl Unexpected Error: $e");
      return Left(ServerFailure("An unexpected error occurred: ${e.toString()}"));
    }
  }


  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    return _tryCatch<User>(() async {
      final userModel = await remoteDataSource.login(email, password);
      // Assuming login in remoteDataSource returns UserModel with an ID
      // and potentially a token if your UserModel includes it.
      // If token is separate from UserModel in API response, adjust remoteDataSource.login
      // For now, let's assume token is part of UserModel or handled internally by remoteDataSource.
      // If your API returns a token upon login, you'd cache it here:
      // await localDataSource.cacheAuthToken(userModel.token ?? 'mock_token_${userModel.id}');
      await localDataSource.cacheAuthToken('mock_token_for_${userModel.id}'); // Example token
      await localDataSource.cacheUser(userModel); // Cache the user model
      return userModel.toEntity();
    });
  }

  @override
  Future<Either<Failure, User>> register(User userEntity, String password) async {
    return _tryCatch<User>(() async {
      // Convert domain User entity to UserModel for the data layer
      final userModelToRegister = UserModel.fromEntity(userEntity);
      final registeredUserModel = await remoteDataSource.register(userModelToRegister, password);
      // Similar to login, handle token caching if applicable
      await localDataSource.cacheAuthToken('mock_token_for_${registeredUserModel.id}');
      await localDataSource.cacheUser(registeredUserModel);
      return registeredUserModel.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return _tryCatch<void>(() async {
      await localDataSource.clearAuthToken();
      await localDataSource.clearCachedUser();
      // Optionally, call a remote logout endpoint if your API has one
      // await remoteDataSource.logout();
      return; // For Future<void>, just return or don't return anything explicitly in async
    });
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    // No network check here usually, as we try local first
    try {
      final userModel = await localDataSource.getCachedUser();
      return Right(userModel.toEntity());
    } on CacheException catch (e) {
      // This means user is not cached or cache is invalid, not necessarily a "failure" to show to user yet.
      // Depending on app logic, you might not return Left immediately.
      // For now, if not in cache, it's a CacheFailure.
      return Left(CacheFailure(e.toString()));
    } catch (e) {
      return Left(CacheFailure("Failed to retrieve current user: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, void>> verifyIdentity(String idNumber, String documentImageUrl) async {
    return _tryCatch<void>(() async {
      // This would typically involve:
      // 1. Uploading the document image to a storage service (getting a URL)
      // 2. Calling a remoteDataSource method to submit the idNumber and the document URL
      // For now, it's a mock.
      // Example: await remoteDataSource.submitVerification(idNumber, documentImageUrl);
      print('Mock: Verifying identity for ID: $idNumber with image: $documentImageUrl');
      await Future.delayed(Duration(seconds: 2)); // Simulate network call
      // On success, remoteDataSource would return success (e.g., true or void)
      return;
    });
  }
}