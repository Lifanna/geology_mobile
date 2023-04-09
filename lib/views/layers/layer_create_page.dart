import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/layer_controller.dart';
import 'package:flutter_application_1/dialogs/messageBoxDialog.dart';
import 'package:flutter_application_1/models/layer_material.dart';
import 'package:flutter_application_1/views/wells/well_index_page.dart';


class LayerCreatePage extends StatefulWidget {
  final int taskID;
  final int wellID;
  final LayerController _layerController = LayerController();

  LayerCreatePage({required this.taskID, required this.wellID});
  @override
  LayerCreatePageState createState() => LayerCreatePageState();
}

var materials = ['Галька', 'Песок', 'Чернозем', 'Глина'];

class LayerCreatePageState extends State<LayerCreatePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _materialController = TextEditingController();
  TextEditingController _commentController = TextEditingController();

  String? material;

  bool sampleObtained = false;
  bool aquifer = false;
  bool drillingStopped = false;

  late List<LayerMaterial> _layerMaterials = [];

  @override
  void initState() {
    super.initState();

    getLayerMaterials();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _materialController.dispose();
    _commentController.dispose();
    super.dispose();
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
        title: Text("Добавление интервала"),
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
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Глубина',
                      hintText: 'Введите глубину интервала'
                    ),
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
                        child: saveBtn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          String name = _nameController.text;
                          String description = _descriptionController.text;
                          String comment = _commentController.text;
                          String _material = material ?? "";
                          widget._layerController.addLayer(widget.wellID, name, description, _material, comment, sampleObtained, aquifer, drillingStopped);

                          continueCallBack() => {
                            Navigator.pop(context),
                            Navigator.push(
                              context, MaterialPageRoute(builder: (_) => WellIndexPage(taskID: widget.taskID, wellID: widget.wellID,))),
                          };
                          BlurryDialog alert = BlurryDialog("Сообщение", "Слой успешно добавлен!", continueCallBack);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
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
