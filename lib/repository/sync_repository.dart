import 'dart:async';
import 'package:flutter_application_1/api_connection/api_connection.dart';
import 'package:flutter_application_1/dao/sync_dao.dart';
import 'package:flutter_application_1/models/api_models.dart';
import 'package:flutter_application_1/repository/sync_interface.dart';
import 'package:flutter_application_1/services/storage_service.dart';


class SyncRepository implements ISyncRepository {
  final syncDao = SyncDao();
  SyncService syncService = SyncService();

  SyncRepository();

  Future<String> synchronize() async {
    String syncronized = "Произошла ошибка! Проверьте корректность заполненных данных";

    var allTasks = await syncDao.buildTasks();

    var allWells = await syncDao.buildWells();

    var allLayers = await syncDao.buildLayers();

    var allWellTasks = await syncDao.buildWellTasks();

    if (allTasks.isEmpty)
      return syncronized += " (не все задания выполнены)";
    
    if (allWells.isEmpty)
      return syncronized += " (отсутствуют скважины)";

    if (allLayers.isEmpty)
      return syncronized += " (отсутствуют слои в скважине(-ах))";

    String? accessToken = await StorageService().readSecureData("accessToken");
    String? refreshToken = await StorageService().readSecureData("refreshToken");
    Token token = Token(token: accessToken!, refreshToken: refreshToken!);

    var syncStatus = await syncService.syncronizeApi(token, allTasks, allWells, allLayers, allWellTasks);

    if (syncStatus){
      syncronized = "Синхронизация успешно произведена!";
    }
    else {
      return syncronized = "Произошла ошибка! Проверьте подключение к сети";
    }

    await syncDao.clearDatabase();

    return syncronized;
  }
}
