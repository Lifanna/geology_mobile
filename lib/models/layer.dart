import 'package:flutter_application_1/models/layer_material.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/models/well.dart';

class Layer {
  late int id;
  late String name;
  late double depth;
  late String description;
  late String comment;
  late Well well;
  late LayerMaterial layerMaterial;
  late User responsible;
  late bool sampleObtained;
  late bool drillingStopped;
  late bool aquifer;

  late String createdAt;
  late String updatedAt;

  Layer();

  factory Layer.fromJson(Map<dynamic, dynamic> data) {
    Layer layer = Layer();
    layer.id = data['id'];
    layer.name = data['name'];
    layer.depth = data['depth'];
    layer.description = data['description'];

    return layer;
  }

  factory Layer.fromDatabaseJson(Map<dynamic, dynamic> data) {
    Layer layer = Layer();
    LayerMaterial layerMaterial = LayerMaterial();
    layerMaterial.name = data['layer_material_name'];
    layer.id = data['id'];
    layer.name = data['name'];
    layer.depth = data['depth'];
    layer.createdAt = data['created_at'];
    layer.updatedAt = data['updated_at'];
    layer.layerMaterial = layerMaterial;
    // layer.responsible = data['responsible_id'];
    // layer.well_id = data['well_id'];
    layer.comment = data['comment'];
    layer.aquifer = data['aquifer'] == 0 ? false : true;
    layer.description = data['description'];
    layer.drillingStopped = data['drilling_stopped'] == 0 ? false : true;
    layer.sampleObtained = data['sample_obtained'] == 0 ? false : true;

    return layer;
  }

  Map<String, dynamic> toDatabaseJson(Layer layer) {
    var databaseJson = {
      'name': layer.name,
      'description': layer.description,
      'comment': layer.comment,
      'depth': layer.depth,
      'well_id': layer.well.id,
      'layer_material_id': layer.layerMaterial.id,
      'responsible_id': layer.responsible.id,
      'sample_obtained': layer.sampleObtained,
      'drilling_stopped': layer.drillingStopped,
      'aquifer': layer.aquifer,
      'created_at': DateTime.now().toString(),
      'updated_at': DateTime.now().toString(),
    };

    return databaseJson;
  }

  Map<String, dynamic> toUpdateDatabaseJson(Layer layer) {
    var databaseJson = {
      'id': layer.id,
      'name': layer.name,
      'description': layer.description,
      'comment': layer.comment,
      'depth': layer.depth,
      'layer_material_id': layer.layerMaterial.id,
      'responsible_id': layer.responsible.id,
      'sample_obtained': layer.sampleObtained == true ? 1 : 0,
      'drilling_stopped': layer.drillingStopped == true ? 1 : 0,
      'aquifer': layer.aquifer == true ? 1 : 0,
      'updated_at': DateTime.now().toString(),
    };

    return databaseJson;
  }
}
