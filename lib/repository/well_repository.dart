import 'dart:async';
import 'package:flutter_application_1/dao/layer_dao.dart';
import 'package:flutter_application_1/dao/well_dao.dart';
import 'package:flutter_application_1/models/line.dart';
import 'package:flutter_application_1/models/well.dart';
import 'package:flutter_application_1/repository/well_interface.dart';


class WellRepository implements IWellRepository {
  final wellDao = WellDao();

  WellRepository();

  @override
  Future<Well?> getWell(int wellId, int taskId) {
    return wellDao.getWellById(wellId, taskId);
  }

  @override
  Future<List<Well>> getWells() {
    // TODO: implement getWells
    throw UnimplementedError();
  }

  @override
  Future<void> addWell(String name, String description, String comment, int lineId, int taskId) async {
    Line line = Line();
    line.id = lineId;
    
    Well well = Well();
    well.name = name;
    well.description = description;
    well.comment = comment;
    well.line = line;

    return await wellDao.addWellByTask(well, taskId);
  }

  Future<void> addWellPhoto(int wellID, String photoPath) async {
    return await wellDao.addWellPhoto(wellID, photoPath);
  }
}
