import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/well_controller.dart';
import 'package:flutter_application_1/views/geology/task_page.dart';


class WellCreatePage extends StatefulWidget {
  final int lineID;
  final int taskID;
  final WellController _wellController = WellController();

  WellCreatePage({required this.lineID, required this.taskID});

  @override
  WellCreatePageState createState() => WellCreatePageState();
}

class WellCreatePageState extends State<WellCreatePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _materialController = TextEditingController();
  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var saveBtn = SizedBox(
      width: width,
      child: Text(
        "Сохранить",
        textAlign: TextAlign.center,
      )
    );

    var backBtn = SizedBox(
      width: width,
      child: Text(
        "Назад",
        textAlign: TextAlign.center,
      )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Новая скважина"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () { 
            Navigator.of(context).pop();
          }, ),
      ),
      body: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 150,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Номер',
                      hintText: 'Введите наименование скважины'
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 150,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Описание',
                      hintText: 'Введите описание скважины'
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                  ),
                ),
              ),
              SizedBox(
                height: 150,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Комментарий',
                      hintText: 'Комментарий'
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                  ),
                ),
              ),
              SizedBox(
                height: 150,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: saveBtn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          String name = _nameController.text;
                          String description = _descriptionController.text;
                          String comment = _commentController.text;
                          int lineId = widget.lineID;
                          widget._wellController.addWell(name, description, comment, lineId, widget.taskID);

                          Navigator.push(
                            context, MaterialPageRoute(builder: (_) => TaskPage(taskID: widget.taskID,)));
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: backBtn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
