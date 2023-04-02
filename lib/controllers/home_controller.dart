import 'package:flutter_application_1/models/api_models.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/repository/user_repository.dart';
import 'package:flutter_application_1/services/status_code.dart';
import 'package:flutter_application_1/services/storage_service.dart';

class HomeController {
  UserRepository _userRepo = UserRepository();

  Future<bool> registerUser(
      String email, String username, String password) async {
    return await _userRepo.register(email, username, password);
  }

  Future<StatusCode> loginUser(String username, String password) async {
    return await _userRepo.login(username, password);
  }
}
