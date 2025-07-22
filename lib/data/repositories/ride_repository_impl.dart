import 'package:dartz/dartz.dart';
import 'package:gowithride/core/errors/exceptions.dart'; // Import custom exceptions
import 'package:gowithride/core/errors/failures.dart';
import 'package:gowithride/data/datasources/remote_data_source.dart';
import 'package:gowithride/data/models/ride_model.dart';   // Import RideModel
import 'package:gowithride/data/models/route_model.dart';  // Import RouteModel
import 'package:gowithride/domain/entities/ride.dart';
import 'package:gowithride/domain/entities/route.dart' as domain_route; // Alias to avoid name clash
import 'package:gowithride/domain/repositories/ride_repository.dart';
// Import NetworkInfo if you plan to use it for network checks
// import 'package:gowithride/core/network/network_info.dart';


class RideRepositoryImpl implements RideRepository {
  final RemoteDataSource remoteDataSource;
  // final NetworkInfo networkInfo; // Optional

  RideRepositoryImpl({
    required this.remoteDataSource,
    // required this.networkInfo, // Optional
  });

  // Helper function to handle common try-catch logic
  Future<Either<Failure, T>> _tryCatch<T>(Future<T> Function() action) async {
    // if (await networkInfo.isConnected == false) {
    //   return Left(NetworkFailure("No internet connection."));
    // }
    try {
      final result = await action();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on AuthenticationException catch (e) {
      return Left(ServerFailure(e.toString())); // Or an AuthFailure
    } on ClientException catch (e) {
      return Left(ServerFailure(e.toString())); // Or a specific ClientFailure
    } on NotFoundException catch (e) {
      return Left(ServerFailure(e.toString())); // Or a specific NotFoundFailure
    } on NoInternetException catch (e) {
      return Left(NetworkFailure(e.toString()));
    } catch (e) {
      print("RideRepositoryImpl Unexpected Error: $e");
      return Left(ServerFailure("An unexpected error occurred: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, List<Ride>>> searchRides(
      String startPoint, String endPoint, DateTime date) async {
    return _tryCatch<List<Ride>>(() async {
      final rideModels = await remoteDataSource.searchRides(startPoint, endPoint, date);
      return rideModels.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, Ride>> createRide(Ride rideEntity) async {
    return _tryCatch<Ride>(() async {
      final rideModelToCreate = RideModel.fromEntity(rideEntity);
      // Assuming remoteDataSource.createRide takes RideModel and returns RideModel
      // You might need to add `createRide` to RemoteDataSource interface and impl
      // final createdRideModel = await remoteDataSource.createRide(rideModelToCreate);

      // MOCK IMPLEMENTATION for createRide in remoteDataSource (if not already there)
      // This part needs to be defined in your RemoteDataSource
      print('Mock: Calling remoteDataSource.createRide with ${rideModelToCreate.toJson()}');
      await Future.delayed(Duration(seconds: 1)); // Simulate network
      final createdRideModel = RideModel( // Simulate backend response
        id: 'ride_${DateTime.now().millisecondsSinceEpoch}',
        driverId: rideModelToCreate.driverId,
        routeId: rideModelToCreate.routeId,
        departureTime: rideModelToCreate.departureTime,
        availableSeats: rideModelToCreate.availableSeats,
        price: rideModelToCreate.price,
      );
      // END MOCK

      return createdRideModel.toEntity();
    });
  }

  @override
  Future<Either<Failure, domain_route.Route>> createRoute(domain_route.Route routeEntity) async {
    return _tryCatch<domain_route.Route>(() async {
      final routeModelToCreate = RouteModel.fromEntity(routeEntity);
      // remoteDataSource.createRoute already exists and takes RouteModel and returns RouteModel
      final createdRouteModel = await remoteDataSource.createRoute(routeModelToCreate);
      return createdRouteModel.toEntity();
    });
  }

  @override
  Future<Either<Failure, bool>> cancelRide(String rideId) async {
    return _tryCatch<bool>(() async {
      // Assuming remoteDataSource.cancelRide takes rideId and returns bool
      // You might need to add `cancelRide` to RemoteDataSource interface and impl
      // final result = await remoteDataSource.cancelRide(rideId);

      // MOCK IMPLEMENTATION for cancelRide in remoteDataSource
      print('Mock: Calling remoteDataSource.cancelRide for ride ID: $rideId');
      await Future.delayed(Duration(milliseconds: 500));
      final result = true; // Simulate success
      // END MOCK

      return result;
    });
  }

  @override
  Future<Either<Failure, bool>> confirmPickup(String rideId, String passengerId) async {
    return _tryCatch<bool>(() async {
      // Add to RemoteDataSource: Future<bool> confirmPickup(String rideId, String passengerId);
      // final result = await remoteDataSource.confirmPickup(rideId, passengerId);

      // MOCK IMPLEMENTATION
      print('Mock: Calling remoteDataSource.confirmPickup for ride: $rideId, passenger: $passengerId');
      await Future.delayed(Duration(milliseconds: 500));
      final result = true;
      // END MOCK
      return result;
    });
  }

  @override
  Future<Either<Failure, bool>> confirmDropoff(String rideId, String passengerId) async {
    return _tryCatch<bool>(() async {
      // Add to RemoteDataSource: Future<bool> confirmDropoff(String rideId, String passengerId);
      // final result = await remoteDataSource.confirmDropoff(rideId, passengerId);

      // MOCK IMPLEMENTATION
      print('Mock: Calling remoteDataSource.confirmDropoff for ride: $rideId, passenger: $passengerId');
      await Future.delayed(Duration(milliseconds: 500));
      final result = true;
      // END MOCK
      return result;
    });
  }
}