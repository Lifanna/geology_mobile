import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/models/api_models.dart';
import 'package:flutter_application_1/services/status_code.dart';

abstract class IUserRepository {
  Future<bool> register(String email, String username, String password);

  Future<StatusCode> login(String username, String password);
}
