import 'package:flutter_application_1/repository/sync_repository.dart';

class SyncController {
  SyncRepository _syncRepo = SyncRepository();

  Future<String> synchronize() async {
    return await _syncRepo.synchronize();
  }
}
