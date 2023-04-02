class Line {
  late int id;
  late String name;

  Line();

  factory Line.fromJson(Map<dynamic, dynamic> data) {
    Line line = Line();
    line.id = data['id'];
    line.name = data['name'];  

    return line;
  }

  factory Line.fromDatabaseJson(Map<dynamic, dynamic> data) {
    Line line = Line();
    line.id = data['line_id'];

    return line;
  }
}
