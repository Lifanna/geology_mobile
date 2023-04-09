import 'package:flutter_application_1/models/well.dart';

abstract class IWellRepository {
  Future<List<Well>> getWells();

  Future<Well?> getWell(int wellId, int taskId);
}
