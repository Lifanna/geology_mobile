class User {
  late int id;
  late String username;
  late String token;
  late String refreshToken;

  User();

  factory User.fromJson(Map<dynamic, dynamic> data) {
    User user = User();

    user.id = data['id'];
    user.username = data['username'];
    user.token = data['token'];

    return user;
  }

  factory User.fromDatabaseJson(Map<dynamic, dynamic> data) {
    User user  = User();
    user.id = data['responsible_id'];

    return user;
  }

  Map<String, dynamic> toDatabaseJson() =>
      {"id": this.id, "username": this.username, "token": this.token};
}
