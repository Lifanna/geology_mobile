import 'dart:async';
import 'package:flutter_application_1/dao/sync_dao.dart';
import 'package:flutter_application_1/repository/storage_interface.dart';

class StorageRepository implements IStorageRepository {
  final syncDao = SyncDao();

  StorageRepository();
  
  @override
  Future<void> clearDatabase() async {
    await syncDao.clearDatabase();
  }
}
