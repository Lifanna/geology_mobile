import 'package:jwt_decoder/jwt_decoder.dart';

class UserLogin {
  String username;
  String password;

  UserLogin({required this.username, required this.password});

  Map<String, dynamic> toDatabaseJson() =>
      {"username": this.username, "password": this.password};
}

class UserRegister {
  String email;
  String username;
  String password;

  UserRegister(
      {required this.email, required this.username, required this.password});

  Map<String, dynamic> toDatabaseJson() => {
        "email": this.email,
        "username": this.username,
        "password": this.password
      };
}

class Token {
  String token;
  String refreshToken;

  Token({required this.token, required this.refreshToken});

  Map<String, dynamic> toDatabaseJson() => {
      
  };

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
        token: json['access'].toString(),
        refreshToken: json['refresh'].toString());
  }

  Map<String, dynamic> fetchUser(String token) {
    Map<String, dynamic> userCreds = JwtDecoder.decode(token);
    print('APIMODELSSSSS ${userCreds}');
    return userCreds;
  }
}
