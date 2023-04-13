import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/layer_controller.dart';
import 'package:flutter_application_1/controllers/well_controller.dart';
import 'package:flutter_application_1/models/layer.dart';
import 'package:flutter_application_1/models/well.dart';
import 'package:flutter_application_1/views/geology/task_page.dart';
import 'package:flutter_application_1/views/layers/layer_create_page.dart';
import 'package:flutter_application_1/views/layers/layer_index_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter_application_1/views/wells/pillar_photo_page.dart';


class WellIndexPage extends StatefulWidget {
  final int taskID;
  final int wellID;
  final LayerController _layerController = LayerController();
  final WellController _wellController = WellController();

  WellIndexPage({required this.taskID, required this.wellID});
  @override
  WellIndexPageState createState() => WellIndexPageState();
}

class WellIndexPageState extends State<WellIndexPage> {
  Well? _well;
  late List<Layer> _layers = [];

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _materialController = TextEditingController();
  TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getWell(widget.wellID, widget.taskID);
    getLayers();
  }

  Future<List<Layer>> getLayers() async {
    _layers = await widget._layerController.getLayers(widget.wellID);

    return _layers;
  }

  Future<void> getWell(int wellId, int taskId) async {
    var well = await widget._wellController.getWell(wellId, taskId);

    setState(() {
      _well = well!;
      _nameController.text = _well?.name ?? "";
      _descriptionController.text = _well?.description ?? "";
      _commentController.text = _well?.comment ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var addLayerBtn = SizedBox(
      width: width,
      child: Text(
        "Добавить интервал",
        textAlign: TextAlign.center,
      )
    );

    var addPhotoBtn = SizedBox(
      width: width,
      child: Text(
        "Фото штаги",
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
        title: Text(_well?.name ?? ""),
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
              Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: SizedBox(
                  height: 80,
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Наименование',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      Text(
                        _well?.line.name ?? "",
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      Text(
                        "Интервалы",
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              Padding (
                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: SizedBox(
                  height: 150,
                  child: FutureBuilder<List<Layer>>(
                    future: getLayers(), // Here you run the check for all queryRows items and assign the fromContact property of each item
                    builder: (context, snapshot) {
                      return ListView.builder(
                        itemCount: _layers.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(_layers[index].name),
                              subtitle: Text(_layers[index].description),
                              onTap: () {
                                Navigator.push(
                                  context, MaterialPageRoute(builder: (_) => LayerIndexPage(
                                    currentLayer: _layers[index], taskID: widget.taskID, wellID: widget.wellID
                                )));
                              },
                            )
                          );
                        }
                      );
                    }
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  height: 100,
                  child: TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Описание',
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  height: 100,
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Комментарий',
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
                        child: addPhotoBtn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () async {
                          await availableCameras().then((value) => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => PillarPhotoPage(cameras: value, taskID: widget.taskID, wellID: widget.wellID,))));
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: addLayerBtn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context, MaterialPageRoute(builder: (_) => LayerCreatePage(taskID: widget.wellID, wellID: widget.wellID,)));
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
                          Navigator.push(
                            context, MaterialPageRoute(builder: (_) => TaskPage(taskID: widget.taskID,)));
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
