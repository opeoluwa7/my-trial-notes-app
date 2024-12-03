import 'package:flutter/material.dart';

class UserModel {
  final String firstName;
  final String lastName;
  final String email;

  UserModel(
      {required this.firstName, required this.lastName, required this.email});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    debugPrint('Mapping Firestore Data: $map');
    return UserModel(
      
      firstName: map['firstName'] ?? 'N/A',
      lastName: map['lastName'] ?? 'N/A',
      email: map['email'] ?? 'N/A'
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }
}
