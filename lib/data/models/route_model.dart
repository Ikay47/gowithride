import 'package:gowithride/domain/entities/route.dart'; // Import the Route entity

class RouteModel {
  final String id;
  final String driverId;
  final String startPoint;
  final String endPoint;
  final List<String> waypoints; // Bus stops can be considered waypoints
  final List<DateTime> availableTimes; // Could represent departure times for this route

  RouteModel({
    required this.id,
    required this.driverId,
    required this.startPoint,
    required this.endPoint,
    this.waypoints = const [],
    required this.availableTimes,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'] as String,
      driverId: json['driverId'] as String,
      startPoint: json['startPoint'] as String,
      endPoint: json['endPoint'] as String,
      waypoints: List<String>.from(json['waypoints']?.map((x) => x) ?? []),
      availableTimes: List<DateTime>.from(
          json['availableTimes']?.map((x) => DateTime.parse(x as String)) ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverId': driverId,
      'startPoint': startPoint,
      'endPoint': endPoint,
      'waypoints': waypoints,
      'availableTimes': availableTimes.map((x) => x.toIso8601String()).toList(),
    };
  }

  // Method to convert RouteModel to Route entity
  Route toEntity() {
    return Route(
      id: id,
      driverId: driverId,
      startPoint: startPoint,
      endPoint: endPoint,
      waypoints: waypoints,
      availableTimes: availableTimes,
    );
  }

  // Factory method to create RouteModel from Route entity
  factory RouteModel.fromEntity(Route entity) {
    return RouteModel(
      id: entity.id,
      driverId: entity.driverId,
      startPoint: entity.startPoint,
      endPoint: entity.endPoint,
      waypoints: entity.waypoints,
      availableTimes: entity.availableTimes,
    );
  }
}