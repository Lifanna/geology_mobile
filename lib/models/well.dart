import 'package:flutter_application_1/models/line.dart';

class Well {
  late int id;

  late String name;

  late String description;

  late String comment;

  late Line line;

  late String created_at;

  late String updated_at;

  Well();

  factory Well.fromJson(Map<dynamic, dynamic> data) {
    Well well = Well();
    well.id = data['id'];
    well.name = data['name'];
    well.description = data['description'];
    well.comment = data['comment'];
    well.line = Line.fromJson(data['line']);
    well.created_at = data['created_at'];
    well.updated_at = data['updated_at'];

    return  well;
  }

  factory Well.forListView(int id, String name) {
    Well well = Well();
    well.id = id;
    well.name = name;
    
    return  well;
  }

  Map<String, dynamic> toDatabaseJson(Well well) {
    var databaseJson = {
      'id': well.id,
      'name': well.name,
      'description': well.description,
      'comment': well.comment,
      'line_id': well.line.id,
      'created_at': well.created_at,
      'updated_at': well.updated_at,
    };

    return databaseJson;
  }

  factory Well.fromDatabaseJson(Map<String, dynamic> dbJson) {
    Well well = Well();

    well.id = dbJson['well_id'];
    well.name = dbJson['well_name'];
    well.description = dbJson['well_description'];
    well.comment = dbJson['comment'];
    well.line = dbJson['line'];
    well.created_at = dbJson['created_at'];
    well.updated_at = dbJson['updated_at'];

    return well;
  }
}
