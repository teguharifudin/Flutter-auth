class User {
  final String? name;
  final String? id;
  final String? password;

  User({this.name, this.id, this.password});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      id: parsedJson['id'].toString(),
      name: parsedJson['name'].toString(),
      password: parsedJson['password'].toString(),
    );
  }
}
