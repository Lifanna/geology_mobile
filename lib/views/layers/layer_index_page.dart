import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/layer_controller.dart';
import 'package:flutter_application_1/dialogs/messageBoxDialog.dart';
import 'package:flutter_application_1/models/layer.dart';
import 'package:flutter_application_1/models/layer_material.dart';
import 'package:flutter_application_1/views/layers/layer_create_page.dart';
import 'package:flutter_application_1/views/layers/layer_list_page.dart';
import 'package:flutter_application_1/views/wells/well_create_page.dart';
import 'package:flutter_application_1/views/wells/well_index_page.dart';


class LayerIndexPage extends StatefulWidget {
  final int taskID;
  final int wellID;
  final Layer currentLayer;
  final LayerController _layerController = LayerController();

  LayerIndexPage({required this.currentLayer, required this.taskID, required this.wellID});

  @override
  LayerIndexPageState createState() => LayerIndexPageState();
}

class LayerIndexPageState extends State<LayerIndexPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _materialController = TextEditingController();
  TextEditingController _commentController = TextEditingController();

  String? material;
  bool sampleObtained = false;
  bool aquifer = false;
  bool drillingStopped = false;

  @override
  void initState() {
    super.initState();

    getLayer();
    getLayerMaterials();
  }

  late List<LayerMaterial> _layerMaterials = [];

  Future<void> getLayer() async {
    Layer layer = await widget._layerController.getLayer(widget.currentLayer.id);

    setState(() {
      material = widget.currentLayer.layerMaterial.name;
      sampleObtained = layer.sampleObtained;
      aquifer = layer.aquifer;
      drillingStopped = layer.drillingStopped;
      _nameController.text = layer.name;
      _descriptionController.text = layer.description;
      _commentController.text = layer.comment;
    });

  }

  Future<void> getLayerMaterials() async {
    var layerMaterials = await widget._layerController.getLayerMaterials();

    setState(() {
      _layerMaterials = layerMaterials;
    });
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

    var backBtn = SizedBox(
      width: width,
      child: Text(
        "Назад",
        textAlign: TextAlign.center,
      )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Бурение"),
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
                height: 100,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Глубина',
                      hintText: 'Введите глубину интервала'
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      RegExp regex = RegExp(r"^[+-]?[0-9]{1,2}([,.][0-9]{1,2})?$");
                      if (!regex.hasMatch(value!))
                        return 'Введите правильное значение';
                      else
                        return null;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 70,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: DropdownButton<String>(
                    value: material,
                    isExpanded: true,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    icon: Icon(Icons.arrow_drop_down),
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    iconSize: 24,
                    hint: Container(
                      child: Text("Выберите материал"),
                    ),
                    items: _layerMaterials.map((layerMaterial) {
                      return DropdownMenuItem<String>(
                        value: layerMaterial.name,
                        child: Text(
                          layerMaterial.name,
                          style: TextStyle(fontSize: 15),
                        ),
                      );
                    }).toList(),
                    // Step 5.
                    onChanged: (String? newValue) {
                      setState(() {
                        material = newValue ?? "";
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 120,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Описание',
                      hintText: 'Введите описание интервала'
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                  ),
                ),
              ),
              SizedBox(
                height: 120,
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
                height: 50,
                child: CheckboxListTile(
                  title: Text("Проба взята"),
                  value: sampleObtained,
                  onChanged: (newValue) {
                    setState(() {
                      sampleObtained = newValue ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                )
              ),
              SizedBox(
                height: 50,
                child: CheckboxListTile(
                  title: Text("Водоносный слой"),
                  value: aquifer,
                  onChanged: (newValue) {
                    setState(() {
                      aquifer = newValue ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                )
              ),
              SizedBox(
                height: 50,
                child: CheckboxListTile(
                  title: Text("Бурение остановлено"),
                  value: drillingStopped,
                  onChanged: (newValue) {
                    setState(() {
                      drillingStopped = newValue ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                )
              ),
              SizedBox(
                height: 150,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          widget._layerController.updateLayer(widget.currentLayer.id, _nameController.text, _descriptionController.text,
                          material!, _commentController.text, sampleObtained, aquifer, drillingStopped);

                          continueCallBack() => {
                              Navigator.pop(context),
                              Navigator.push(
                                context, MaterialPageRoute(builder: (_) => WellIndexPage(taskID: widget.taskID, wellID: widget.wellID,))),
                          };

                          BlurryDialog alert = BlurryDialog("Сообщение", "Интервал успешно обновлен!", continueCallBack);

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        },
                        child: saveBtn,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          Navigator.push(
                  context, MaterialPageRoute(builder: (_) => WellIndexPage(taskID: widget.taskID, wellID: widget.wellID,)));
                        },
                        child: backBtn,
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
