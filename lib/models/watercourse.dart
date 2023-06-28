class WaterCourse {
  late int id;
  late String name;

  late String created_at;

  late String updated_at;

  WaterCourse();
  
  factory WaterCourse.fromDatabaseJson(Map<dynamic, dynamic> data) {
    WaterCourse watercourse = WaterCourse();
    watercourse.id = data['watercourse_id'];
    watercourse.name = data['watercourse_name'];

    return watercourse;
  }

  Map<String, dynamic> toDatabaseJson(WaterCourse waterCourse) {
    var databaseJson = {
      'name': waterCourse.name,
      'created_at': waterCourse.created_at,
      'updated_at': waterCourse.updated_at
    };

    return databaseJson;
  }
}
