import 'dart:async';
import 'dart:convert';
import 'package:flutter_application_1/models/layer.dart';
import 'package:flutter_application_1/models/layer_material.dart';
import 'package:flutter_application_1/models/storage_item.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/services/status_code.dart';
import 'package:flutter_application_1/services/storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/dao/dao.dart';
import 'package:flutter_application_1/models/api_models.dart';

final _base = "http://192.168.1.62:8000";
// final _base = "http://192.168.43.178:8000";
final _signInURL = "/api/token/";
final _signUpEndpoint = "/api/register/";
final _sessionEndpoint = "/api/token/refresh/";
final _tokenURL = _base + _signInURL;
final _refreshTokenURL = _base + _sessionEndpoint;
final _signUpURL = _base + _signUpEndpoint;
final _fetchTasksURL = _base + "/api/tasks/";
final _fetchLayerMaterialsURL = _base + "/api/layer_materials/";

Future<bool> registerApi(UserRegister userRegister) async {
  Future<bool> success = Future.value(false);
  final http.Response response = await http.post(
    Uri.parse(_signUpURL),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(userRegister.toDatabaseJson()),
  );
  if (response.statusCode == 200) {
    success = Future.value(true);
  } else {
    // print(json.decode(response.body).toString());
    // throw Exception(json.decode(response.body));
  }

  return success;
}

Future<StatusCode> loginApi(UserLogin userLogin) async {
  final http.Response response = await http.post(
    Uri.parse(_tokenURL),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(userLogin.toDatabaseJson()),
  );

  if (response.statusCode == 200) {
    Token token = Token.fromJson(json.decode(response.body));

    // UserDao userDao = UserDao();
    // userDao.addTokenToDb(token.token, token.refreshToken);

    // var users = await userDao.getUserToken();

    // userID = userCreds.values.last;

    StatusCode statusCode = StatusCode(
      statusCode: response.statusCode.toString(), 
      message: response.body,
    );
    statusCode.token = token;

    return statusCode;
  } else {
    throw Exception(json.decode(response.body));
  }
}

Future<List<Task>> fetchTasks(Token token) async {
  final http.Response response = await http.get(
    Uri.parse(_fetchTasksURL),
    headers: <String, String>{
      'Authorization': 'Bearer ${token.token}',
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  List<Task> tasks = [];

  if (response.statusCode == 200) {
    List<dynamic> tasksJson = await json.decode(utf8.decode(response.bodyBytes));

    for(var element in tasksJson) {
      Task task = Task.fromJson(element);
      print(task);
      tasks.add(task);
    }
  }
  else if (response.statusCode == 401) {
    Token newToken = await refreshToken(token);
    await fetchTasks(newToken);
  }
  else {
    throw Exception(json.decode(response.body));
  }

  return tasks;
}

Future<Token> refreshToken(Token token) async {
  final http.Response response = await http.post(
    Uri.parse(_refreshTokenURL),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({"refresh": token.refreshToken}),
  );

  if (response.statusCode == 200) {
    token.token = jsonDecode(response.body)['access'];
    StorageService().writeSecureData(StorageItem("accessToken", token.token));
    return token;
  } else {
    throw Exception(json.decode(utf8.decode(response.bodyBytes)));
  }
}

class LayerService {
  
  Future<List<LayerMaterial>> getLayerMaterialsFromApi(Token token) async {
    final http.Response response = await http.get(
      Uri.parse(_fetchLayerMaterialsURL),
      headers: <String, String>{
        'Authorization': 'Bearer ${token.token}',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    List<LayerMaterial> layerMaterials = [];

    if (response.statusCode == 200) {
      List<dynamic> layerMaterialsJson = await json.decode(utf8.decode(response.bodyBytes));
      print("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY: ${layerMaterialsJson}");


      for(var element in layerMaterialsJson) {
        LayerMaterial layerMaterial = LayerMaterial.fromJson(element);
        layerMaterials.add(layerMaterial);
      }
    }
    else if (response.statusCode == 401) {
      Token newToken = await refreshToken(token);
      await fetchTasks(newToken);
    }
    else {
      throw Exception(json.decode(response.body));
    }

    return layerMaterials;
  }
}