import 'dart:async';
import 'dart:convert';
import 'package:flutter_application_1/models/layer_material.dart';
import 'package:flutter_application_1/models/storage_item.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/services/status_code.dart';
import 'package:flutter_application_1/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/api_models.dart';

final _base = "http://192.168.1.62:8000";
// final _base = "http://192.168.188.102:8000";
final _signInURL = "/api/token/";
final _sessionEndpoint = "/api/token/refresh/";
final _tokenURL = _base + _signInURL;
final _refreshTokenURL = _base + _sessionEndpoint;
final _fetchTasksURL = _base + "/api/tasks/";
final _fetchLayerMaterialsURL = _base + "/api/layer_materials/";
final _syncronizeURL = _base + "/api/synchronize/";


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

    print("KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK");

    List<LayerMaterial> layerMaterials = [];

    if (response.statusCode == 200) {
      List<dynamic> layerMaterialsJson = await json.decode(utf8.decode(response.bodyBytes));

      for(var element in layerMaterialsJson) {
        LayerMaterial layerMaterial = LayerMaterial.fromJson(element);
        layerMaterials.add(layerMaterial);
      }
    }
    else if (response.statusCode == 401) {
      Token newToken = await refreshToken(token);
      await getLayerMaterialsFromApi(newToken);
    }
    else {
      throw Exception(json.decode(response.body));
    }

    print("KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK ${layerMaterials}");
    return layerMaterials;
  }
}

class SyncService {
  Future<bool> syncronizeApi(Token token, List<Map<String,dynamic>> tasks, List<Map<String,dynamic>> wells, List<Map<String,dynamic>> layers, List<Map<String,dynamic>> wellTasks) async {
    var syncronized = false;
    // print("QQQQQQQQQQQQQQQWWWWWWWW: ${jsonEncode({
    //         'tasks': tasks,
    //         'wells': wells,
    //         'layers': layers,
    //         'wellTasks': wellTasks,
    //       })}");
    // try {
      final http.Response response = await http.post(
        Uri.parse(_syncronizeURL),
          headers: <String, String>{
            'Authorization': 'Bearer ${token.token}',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'tasks': tasks,
            'wells': wells,
            'layers': layers,
            'wellTasks': wellTasks,
          })
      );
      print("YYYYYY: ${response.statusCode}");
      syncronized = response.statusCode == 200;
    // } finally {
      return syncronized;
    // }
  }
}