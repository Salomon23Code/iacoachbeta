class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? password;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'] ?? json['userId'];
    final firstNameValue = json['firstName'] ?? json['first_name'] ?? '';
    final lastNameValue = json['lastName'] ?? json['last_name'] ?? '';
    final emailValue = json['email'] ?? '';
    final passwordValue = json['password'];

    return User(
      id: idValue is int
          ? idValue
          : int.tryParse(idValue?.toString() ?? '') ?? 0,
      firstName: firstNameValue.toString(),
      lastName: lastNameValue.toString(),
      email: emailValue.toString(),
      phone: json['phone']?.toString(),
      password: passwordValue?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }

  String get fullName => '$firstName $lastName';

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
    );
  }
}
