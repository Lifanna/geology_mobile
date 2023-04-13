import 'package:flutter_application_1/models/well.dart';
import 'package:flutter_application_1/repository/well_repository.dart';

class WellController {
  WellRepository _wellRepo = WellRepository();
  
  Future<List<Well>> getWells() async {
    return await _wellRepo.getWells();
  }
  
  Future<Well?> getWell(int wellId, int taskId) async {
    return await _wellRepo.getWell(wellId, taskId);
  }
  
  Future<void> addWell(String name, String description, String comment, int lineId, int taskId) async {
    return await _wellRepo.addWell(name, description, comment, lineId, taskId);
  }

  Future<void> addWellPhoto(int wellID, String photoPath) async {
    return await _wellRepo.addWellPhoto(wellID, photoPath);
  }
}
