import 'package:flutter_application_1/models/line.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/models/watercourse.dart';

// enum LicenseStatuses {
//   _new, 
//   in_progress, 
//   complete;

//   String toJson() => name;
//   static LicenseStatuses fromJson(int json) => values.indexWhere(json);
// }

class License {
  late int id;

  late String short_name;

  late String name;

  late User geologist;

  late int status;

  late String used_enginery;

  // late List<WaterCourse> watercourses;

  late List<Line> lines;

  late String comment;

  late String created_at;

  late String updated_at;

  License();

  factory License.fromJson(Map<String, dynamic> data) {
    List<Line> lines = [];
    
    data['lines'].forEach((lineJson) {
      Line line = Line.fromJson(lineJson);
      lines.add(line);
    });

    License license = License();
    license.id = data['id'];
    license.short_name = data['short_name'];
    license.name = data['name'];
    license.geologist = User.fromJson(data['geologist']);
    license.status = data['status'];
    license.used_enginery = data['used_enginery'];
    // license.this.watercourses = data['watercourses'];
    license.lines = lines;
    license.comment = data['comment'];
    license.created_at = data['created_at'];
    license.updated_at = data['updated_at'];

    return license;
  }

  factory License.fromTaskJson(int id) {
    License license = License();

    license.id = id;

    return license;
  }
}
