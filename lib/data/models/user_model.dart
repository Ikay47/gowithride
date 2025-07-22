import 'package:gowithride/domain/entities/user.dart'; // Import the User entity

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String userType; // 'driver' or 'passenger'
  final bool isVerified;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    this.isVerified = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      userType: json['userType'] as String,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'userType': userType,
      'isVerified': isVerified,
    };
  }

  // Method to convert UserModel to User entity
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      phone: phone,
      userType: userType,
      isVerified: isVerified,
    );
  }

  // Optional: Factory method to create UserModel from User entity
  // This is useful when you need to send domain entity data to the data layer
  factory UserModel.fromEntity(User entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      userType: entity.userType,
      isVerified: entity.isVerified,
    );
  }
}