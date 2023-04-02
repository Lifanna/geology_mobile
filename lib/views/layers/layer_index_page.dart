import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/layer_controller.dart';
import 'package:flutter_application_1/models/layer.dart';
import 'package:flutter_application_1/models/layer_material.dart';
import 'package:flutter_application_1/views/layers/layer_create_page.dart';
import 'package:flutter_application_1/views/wells/well_create_page.dart';


class LayerIndexPage extends StatefulWidget {
  final Layer currentLayer;
  final LayerController _layerController = LayerController();

  LayerIndexPage({required this.currentLayer});

  @override
  LayerIndexPageState createState() => LayerIndexPageState();
}

class LayerIndexPageState extends State<LayerIndexPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _materialController = TextEditingController();
  TextEditingController _commentController = TextEditingController();

  String? material;

  @override
  void initState() {
    super.initState();
    setState(() {
      material = widget.currentLayer.layerMaterial.name;
      _nameController.text = widget.currentLayer.name;
      _descriptionController.text = widget.currentLayer.description;
      _commentController.text = widget.currentLayer.comment;
    });

    getLayerMaterials();
  }

  late List<LayerMaterial> _layerMaterials = [];

  Future<void> getLayerMaterials() async {
    var layerMaterials = await widget._layerController.getLayerMaterials();

    setState(() {
      _layerMaterials = layerMaterials;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Бурение"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () { 
            Navigator.of(context).pop();
          }, ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Padding(
              padding: EdgeInsets.all(10),
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
          Padding(
            padding: EdgeInsets.all(10),
            child: DropdownButton<String>(
              value: widget.currentLayer.layerMaterial.name,
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
          Flexible(
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
          Flexible(
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
          ElevatedButton(
            child: Text('Сохранить'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              // Navigator.push(
              //   context, MaterialPageRoute(builder: (_) => LayerCreatePage()));
            },
          ),
        ],
      ),
    );
  }
}
