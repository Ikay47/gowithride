import 'package:gowithride/domain/entities/ride.dart'; // Import the Ride entity

class RideModel {
  final String id;
  final String driverId;
  final String routeId;
  final DateTime departureTime;
  final int availableSeats;
  final double price;
  // Note: The 'status' field from the Ride entity is not present in RideModel.
  // We'll handle this during conversion.

  RideModel({
    required this.id,
    required this.driverId,
    required this.routeId,
    required this.departureTime,
    required this.availableSeats,
    required this.price,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['id'] as String,
      driverId: json['driverId'] as String,
      routeId: json['routeId'] as String,
      departureTime: DateTime.parse(json['departureTime'] as String),
      availableSeats: json['availableSeats'] as int,
      price: (json['price'] as num).toDouble(),
      // status: json['status'] as String?, // If your API ever returns status for RideModel
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverId': driverId,
      'routeId': routeId,
      'departureTime': departureTime.toIso8601String(),
      'availableSeats': availableSeats,
      'price': price,
      // 'status': status, // If your API ever expects status for RideModel
    };
  }

  // Method to convert RideModel to Ride entity
  Ride toEntity() {
    return Ride(
      id: id,
      driverId: driverId,
      routeId: routeId,
      departureTime: departureTime,
      availableSeats: availableSeats,
      price: price,
      status: 'scheduled', // Default status, or derive if possible from model data
      // If your API *does* return status in RideModel, use it here.
    );
  }

  // Optional: Factory method to create RideModel from Ride entity
  factory RideModel.fromEntity(Ride entity) {
    return RideModel(
      id: entity.id,
      driverId: entity.driverId,
      routeId: entity.routeId,
      departureTime: entity.departureTime,
      availableSeats: entity.availableSeats,
      price: entity.price,
      // The 'status' from the entity is not mapped to the model here,
      // as RideModel doesn't have a status field.
      // If your backend API expects a status for ride creation/update, add it to RideModel.
    );
  }
}