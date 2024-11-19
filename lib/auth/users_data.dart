class UserData {
  final String firstName;
  final String lastName;
  final String email;

  UserData(
      {required this.firstName, required this.lastName, required this.email});

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email']
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
