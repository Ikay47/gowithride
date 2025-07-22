import 'dart:convert'; // For jsonEncode if you were making real API calls
import 'package:gowithride/core/errors/exceptions.dart';
import 'package:gowithride/data/models/ride_model.dart';
import 'package:gowithride/data/models/route_model.dart';
import 'package:gowithride/data/models/user_model.dart'; // Assuming this exists and is correct
import 'package:http/http.dart' as http;

abstract class RemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(UserModel user, String password);
  Future<List<RideModel>> searchRides(String from, String to, DateTime date);
  Future<RouteModel> createRoute(RouteModel route);
  Future<bool> confirmPayment(String rideId, double amount);
  // You'll need to add the missing methods from RideRepositoryImpl here as well
  // e.g., createRide, cancelRide, confirmPickup, confirmDropoff
  Future<RideModel> createRide(RideModel ride);
  Future<bool> cancelRide(String rideId);
  Future<bool> confirmPickup(String rideId, String passengerId);
  Future<bool> confirmDropoff(String rideId, String passengerId);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;
  final String baseUrl; // Example: "https://api.yourdomain.com"

  RemoteDataSourceImpl({required this.client, required this.baseUrl});

  // Helper function for common API call structure (optional, but good practice)
  Future<T> _performApiCall<T>({
    required Future<http.Response> Function() apiCall,
    required T Function(dynamic jsonData) onSuccess,
    String? successMessage, // Optional: For operations that don't return complex data
  }) async {
    try {
      final response = await apiCall();

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (successMessage != null && response.body.isEmpty) {
          if (T == bool) {
            return true as T;
          }
          throw ServerException("API returned success but no data for expected type T");
        }
        // Handle cases where response.body might be empty but still valid for some T types
        if (response.body.isEmpty && T != bool && T != String) { // Example: if expecting void essentially for T
          // This needs careful handling. If T is void, this structure is problematic.
          // For now, assuming T will expect some JSON if not bool.
        }
        return onSuccess(json.decode(response.body));
      } else if (response.statusCode == 400) {
        throw ClientException(json.decode(response.body)['message'] ?? 'Bad Request');
      } else if (response.statusCode == 401) {
        throw AuthenticationException(json.decode(response.body)['message'] ?? 'Unauthorized');
      } else if (response.statusCode == 403) {
        throw ClientException(json.decode(response.body)['message'] ?? 'Forbidden');
      } else if (response.statusCode == 404) {
        throw NotFoundException(json.decode(response.body)['message'] ?? 'Resource not found');
      } else if (response.statusCode >= 500) {
        throw ServerException('Server Error: ${response.statusCode} - ${response.reasonPhrase}');
      } else {
        throw ServerException('Unhandled API Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } on http.ClientException catch (e) {
      throw NoInternetException('Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ServerException('Error parsing server response: ${e.message}');
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    // Current Mock Implementation WITH PRE-REGISTERED USERS
    try {
      print('Attempting login for: $email with password: $password'); // Good for debugging
      await Future.delayed(Duration(seconds: 1)); // Mock network delay

      // --- START PRE-REGISTERED USER LOGIC ---
      if (email.toLowerCase() == "driver@app.com" && password == "password123") {
        print('Mock login successful for DRIVER');
        return UserModel(
          id: 'driver_001',
          name: 'Test Driver One',
          email: email,
          phone: '080DRIVER001',
          userType: 'driver',
          isVerified: true,
        );
      } else if (email.toLowerCase() == "passenger@app.com" && password == "password123") {
        print('Mock login successful for PASSENGER');
        return UserModel(
          id: 'passenger_001',
          name: 'Test Passenger One',
          email: email,
          phone: '080PASSENGER001',
          userType: 'passenger',
          isVerified: true,
        );
      } else if (email.toLowerCase() == "unverified@app.com" && password == "password123") {
        print('Mock login successful for UNVERIFIED USER');
        return UserModel(
          id: 'user_unverified_001',
          name: 'Unverified User',
          email: email,
          phone: '080UNVERIFIED',
          userType: 'passenger', // Or 'driver'
          isVerified: false,
        );
      }
      // --- END PRE-REGISTERED USER LOGIC ---
      else {
        // Simulate failed login for any other credentials
        print('Mock login failed for: $email');
        throw AuthenticationException('Invalid credentials. Please try again.');
      }
    } on AuthenticationException {
      rethrow;
    } catch (e) {
      print('Login error in RemoteDataSource: $e');
      throw ServerException('An unexpected error occurred during login.');
    }
  }

  @override
  Future<UserModel> register(UserModel user, String password) async {
    // Current Mock Implementation
    try {
      print('Attempting registration for: ${user.email}');
      await Future.delayed(Duration(seconds: 1));

      // Simulate successful registration
      return UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: user.name,
        email: user.email,
        phone: user.phone,
        userType: user.userType,
        isVerified: false, // New users start as unverified
      );
    } catch (e) {
      print('Registration error: $e');
      throw ServerException('An unexpected error occurred during registration.');
    }
  }

  @override
  Future<List<RideModel>> searchRides(String from, String to, DateTime date) async {
    // Current Mock Implementation
    try {
      print('Searching rides from: $from to: $to on: $date');
      await Future.delayed(Duration(milliseconds: 500));
      return List.generate(3, (index) => RideModel(
        id: 'ride_$index',
        driverId: 'driver_$index',
        routeId: 'route_for_ride_$index',
        departureTime: date.add(Duration(hours: index * 2)),
        availableSeats: 3 - index,
        price: 1500.0 + (index * 500),
      ));
    } catch (e) {
      print('Search rides error: $e');
      throw ServerException('An unexpected error occurred while searching for rides.');
    }
  }

  @override
  Future<RouteModel> createRoute(RouteModel routeDataFromUseCase) async {
    // Current Mock Implementation
    try {
      print('Creating route from: ${routeDataFromUseCase.startPoint} to ${routeDataFromUseCase.endPoint}');
      await Future.delayed(Duration(seconds: 1));
      return RouteModel(
        id: 'route_${DateTime.now().millisecondsSinceEpoch}',
        driverId: routeDataFromUseCase.driverId,
        startPoint: routeDataFromUseCase.startPoint,
        endPoint: routeDataFromUseCase.endPoint,
        waypoints: routeDataFromUseCase.waypoints,
        availableTimes: routeDataFromUseCase.availableTimes,
      );
    } catch (e) {
      print('Create route error: $e');
      throw ServerException('An unexpected error occurred while creating the route.');
    }
  }

  @override
  Future<bool> confirmPayment(String rideId, double amount) async {
    // Current Mock Implementation
    try {
      print('Confirming payment for ride: $rideId, amount: $amount');
      await Future.delayed(Duration(milliseconds: 800));
      return true;
    } catch (e) {
      print('Confirm payment error: $e');
      throw ServerException('An unexpected error occurred during payment confirmation.');
    }
  }

  // --- Implementations for new methods required by RideRepository ---
  @override
  Future<RideModel> createRide(RideModel ride) async {
    try {
      print('Mock Remote: Creating ride for driver: ${ride.driverId}, route: ${ride.routeId}');
      await Future.delayed(Duration(seconds: 1));
      return RideModel(
        id: 'new_ride_${DateTime.now().millisecondsSinceEpoch}',
        driverId: ride.driverId,
        routeId: ride.routeId,
        departureTime: ride.departureTime,
        availableSeats: ride.availableSeats,
        price: ride.price,
      );
    } catch (e) {
      print('Create ride error in remote data source: $e');
      throw ServerException('Failed to create ride: ${e.toString()}');
    }
  }

  @override
  Future<bool> cancelRide(String rideId) async {
    try {
      print('Mock Remote: Cancelling ride ID: $rideId');
      await Future.delayed(Duration(milliseconds: 500));
      return true; // Simulate success
    } catch (e) {
      throw ServerException('Failed to cancel ride: ${e.toString()}');
    }
  }

  @override
  Future<bool> confirmPickup(String rideId, String passengerId) async {
    try {
      print('Mock Remote: Confirming pickup for ride: $rideId, passenger: $passengerId');
      await Future.delayed(Duration(milliseconds: 500));
      return true; // Simulate success
    } catch (e) {
      throw ServerException('Failed to confirm pickup: ${e.toString()}');
    }
  }

  @override
  Future<bool> confirmDropoff(String rideId, String passengerId) async {
    try {
      print('Mock Remote: Confirming dropoff for ride: $rideId, passenger: $passengerId');
      await Future.delayed(Duration(milliseconds: 500));
      return true; // Simulate success
    } catch (e) {
      throw ServerException('Failed to confirm dropoff: ${e.toString()}');
    }
  }
}