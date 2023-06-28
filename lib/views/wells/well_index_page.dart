import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/layer_controller.dart';
import 'package:flutter_application_1/controllers/well_controller.dart';
import 'package:flutter_application_1/dialogs/messageBoxDialog.dart';
import 'package:flutter_application_1/models/layer.dart';
import 'package:flutter_application_1/models/well.dart';
import 'package:flutter_application_1/views/geology/task_page.dart';
import 'package:flutter_application_1/views/layers/layer_create_page.dart';
import 'package:flutter_application_1/views/layers/layer_index_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter_application_1/views/layers/layer_materials_colors.dart';
import 'package:flutter_application_1/views/wells/pillar_photo_page.dart';


class WellIndexPage extends StatefulWidget {
  final int taskID;
  final String short_name;
  final String line_name;
  final int wellID;
  final LayerController _layerController = LayerController();
  final WellController _wellController = WellController();

  WellIndexPage({required this.taskID, required this.wellID, required this.short_name, required this.line_name});
  @override
  WellIndexPageState createState() => WellIndexPageState();
}

class WellIndexPageState extends State<WellIndexPage> {
  Well? _well;
  late List<Layer> _layers = [];

  late Future<Well?>? fetchWell;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _materialController = TextEditingController();
  TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchWell = getWell(widget.wellID, widget.taskID);
    getLayers();

  }

  Future<List<Layer>> getLayers() async {
    _layers = await widget._layerController.getLayers(widget.wellID);

    return _layers;
  }

  Future<Well?> getWell(int wellId, int taskId) async {
    final well = await widget._wellController.getWell(wellId, taskId);

    setState(() {
      _well = well;
      _nameController.text = well?.name ?? "";
      _descriptionController.text = well?.description ?? "";
      _commentController.text = well?.comment ?? "";
    });

    return well;
  }

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

    var addLayerBtn = SizedBox(
      width: width,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          Icon(Icons.add),
          Text(
            " интервал",
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
        title: Text("Скважина " + (_well?.name ?? "")),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () { 
            // Navigator.of(context).pop();
            Navigator.pop(context);
            Navigator.push(
              context, MaterialPageRoute(builder: (_) => TaskPage(
                taskID: widget.taskID,
                short_name: widget.short_name,
            )));
          },),
      ),
      body: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: FutureBuilder<Well?>(
          future: fetchWell,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Ошибка получения данных из базы данных'),
              );
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(
                child: Text('Данные скважины не найдены'),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: SizedBox(
                        height: 80,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1 /*or any integer value above 0 (optional)*/,
                                  child: TextField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Наименование',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    widget.line_name,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 1, 
                                  child: ElevatedButton(
                                    child: addPhotoBtn,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    onPressed: () async {
                                      await availableCameras().then((value) => Navigator.push(context,
                                      MaterialPageRoute(builder: (_) => PillarPhotoPage(cameras: value, taskID: widget.taskID, wellID: widget.wellID, short_name: widget.short_name, line_name: widget.line_name))));
                                    },
                                  ),
                                ),
                              ],
                            ),

                          // TextField(
                          //   controller: _nameController,
                          //   decoration: InputDecoration(
                          //     border: OutlineInputBorder(),
                          //     labelText: 'Наименование',
                          //   ),
                          // ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text(
                              widget.line_name,
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Padding(
                        padding: EdgeInsets.all(10),
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
                    SizedBox(
                      height: 200,
                      child: Padding(
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
                                    color: LayerMaterialColorPicker.getMaterialColor(_layers[index].layerMaterial.name),
                                    child: ListTile(
                                      title: Flex(
                                        direction: Axis.horizontal,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(_layers[index].name),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              (_layers[index].description.length > 30)
                                                  ? _layers[index].description.substring(0, _layers[index].description.lastIndexOf(' ', 30)) + '...'
                                                  : _layers[index].description,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          if (_layers[index].sampleObtained == true) Expanded(
                                            flex: 1,
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Icon(Icons.check),
                                          ),
                                          ),
                                        ],
                                      ),
                                      // subtitle: Text(_layers[index].layerMaterial.name),
                                      onTap: () {
                                        Navigator.push(
                                          context, MaterialPageRoute(builder: (_) => LayerIndexPage(
                                            currentLayer: _layers[index], taskID: widget.taskID, wellID: widget.wellID, short_name: widget.short_name, line_name: widget.line_name,
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
                    ),
                    SizedBox(
                      height: 100,
                      child: Padding(
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
                    ),
                    SizedBox(
                      height: 100,
                      child: Padding(
                        padding: EdgeInsets.all(10),
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
                      height: 200,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: ElevatedButton(
                              child: saveBtn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () async {
                                widget._wellController.updateWell(widget.wellID, _nameController.text, _descriptionController.text,
                                _commentController.text);

                                continueCallBack() => {
                                    Navigator.pop(context),
                                    Navigator.push(
                                      context, MaterialPageRoute(builder: (_) => WellIndexPage(taskID: widget.taskID, wellID: widget.wellID, short_name: widget.short_name, line_name: widget.line_name,))),
                                };

                                BlurryDialog alert = BlurryDialog("Сообщение", "Скважина успешно обновлена!", continueCallBack);

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alert;
                                  },
                                );
                              },
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          //   child: ElevatedButton(
                          //     child: addPhotoBtn,
                          //     style: ElevatedButton.styleFrom(
                          //       backgroundColor: Colors.green,
                          //     ),
                          //     onPressed: () async {
                          //       await availableCameras().then((value) => Navigator.push(context,
                          //       MaterialPageRoute(builder: (_) => PillarPhotoPage(cameras: value, taskID: widget.taskID, wellID: widget.wellID, short_name: widget.short_name,))));
                          //     },
                          //   ),
                          // ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: ElevatedButton(
                              child: addLayerBtn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context, MaterialPageRoute(builder: (_) => LayerCreatePage(taskID: widget.taskID, wellID: widget.wellID, short_name: widget.short_name, line_name: widget.line_name,)));
                              },
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          //   child: ElevatedButton(
                          //     child: backBtn,
                          //     style: ElevatedButton.styleFrom(
                          //       backgroundColor: Colors.green,
                          //     ),
                          //     onPressed: () {
                          //       Navigator.pop(context);
                          //       Navigator.push(
                          //         context, MaterialPageRoute(builder: (_) => TaskPage(
                          //           taskID: widget.taskID,
                          //           short_name: widget.short_name,
                          //       )));
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        ),
      ),
    );
  }
}
