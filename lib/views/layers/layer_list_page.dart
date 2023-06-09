import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/layer_controller.dart';
import 'package:flutter_application_1/models/layer.dart';
import 'package:flutter_application_1/views/layers/layer_create_page.dart';
import 'package:flutter_application_1/views/layers/layer_index_page.dart';


class LayerListPage extends StatefulWidget {
  final int taskID;
  final int wellID;
  final String short_name;
  final String line_name;
  final LayerController _layerController = LayerController();

  LayerListPage({required this.taskID, required this.wellID, required this.short_name, required this.line_name});
  @override
  LayerListPageState createState() => LayerListPageState();
}

class LayerListPageState extends State<LayerListPage> {
  late List<Layer> _layers = [];

  @override
  void initState() {
    super.initState();
  }

  Future<List<Layer>> getLayers() async {
    _layers = await widget._layerController.getLayers(widget.wellID);

    return _layers;
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
        children: <Widget>[
          Flexible(
            flex: 2,
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
                              currentLayer: _layers[index], taskID: widget.taskID, wellID: widget.wellID, short_name: widget.short_name, line_name: widget.line_name,
                          )));
                        },
                      )
                    );
                  }
                );
              }
            )
          ),
          ElevatedButton(
            child: Text('Добавить интервал'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              Navigator.push(
                context, MaterialPageRoute(builder: (_) => LayerCreatePage(taskID: widget.taskID, wellID: widget.wellID, short_name: widget.short_name, line_name: widget.line_name,)));
            },
          ),
        ],
      ),
    );
  }
}
