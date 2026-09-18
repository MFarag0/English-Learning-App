class User {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final String role;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.role,
  });

  // Factory constructor to create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    // Be tolerant to different JSON key styles (e.g., firstName vs firstname)
    String id = json['id'] ?? json['email'] ?? '';
    String firstname = json['firstname'] ?? json['firstName'] ?? '';
    String lastname = json['lastname'] ?? json['lastName'] ?? '';
    String email = json['email'] ?? '';
    String password = json['password'] ?? '';
    String role = json['role'] ?? '';

    return User(
      id: id.toString(),
      firstname: firstname.toString(),
      lastname: lastname.toString(),
      email: email.toString(),
      password: password.toString(),
      role: role.toString(),
    );
  }

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}
