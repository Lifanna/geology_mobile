import 'package:flutter_application_1/repository/storage_repository.dart';
import 'package:flutter_application_1/repository/sync_repository.dart';

class StorageController {
  StorageRepository _storageRepo = StorageRepository();

  Future<void> clearDatabase() async {
    print("CSDVVVCVCVCXVVVVVVVVVVVVVVVVVVVVVv");
    await _storageRepo.clearDatabase();
  }
}
