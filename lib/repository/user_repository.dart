import 'dart:async';
import 'dart:convert';
import 'package:flutter_application_1/models/storage_item.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/services/status_code.dart';
import 'package:flutter_application_1/services/storage_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_application_1/dao/dao.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/models/api_models.dart';
import 'package:flutter_application_1/api_connection/api_connection.dart';
import 'package:flutter_application_1/repository/user_interface.dart';

class UserRepository implements IUserRepository {
  final userDao = UserDao();

  UserRepository();

  @override
  Future<StatusCode> login(String username, String password) async {
    UserLogin userLogin = UserLogin(username: username, password: password);
    StatusCode statusCode = await loginApi(userLogin);
    Token token = statusCode.token!;
    Map<String, dynamic> userCreds = token.fetchUser(token.token);

    StorageService().writeSecureData(StorageItem("accessToken", token.token));
    StorageService().writeSecureData(StorageItem("refreshToken", token.refreshToken));
    StorageService().writeSecureData(StorageItem("userID", userCreds.values.last.toString()));

    return statusCode;
  }
}
