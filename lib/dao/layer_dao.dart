import 'package:flutter_application_1/database/database_provider.dart';
import 'package:flutter_application_1/models/layer.dart';
import 'package:flutter_application_1/models/layer_material.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/api_connection/api_connection.dart';
import 'package:flutter_application_1/models/api_models.dart';
import 'package:flutter_application_1/models/well.dart';

class LayerDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<List<Layer>> getLayers(int wellId) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    List<Layer> wells = [];

    result = await db.rawQuery("""
      SELECT 
        ml.id, ml.description, mlm.name as layer_material_name,
        ml.created_at, ml.updated_at, 
        ml.comment, ml.aquifer, ml.description, ml.drilling_stopped, ml.sample_obtained 
      FROM main_layer ml
      JOIN main_layermaterial mlm ON 
      mlm.id = ml.layer_material_id
      WHERE ml.well_id = ${wellId}
    """);

    for (var layerJson in result) {
      wells.add(Layer.fromDatabaseJson(layerJson));
    }
    print("AZAZAZAZAZA: ${wells}");

    return wells;
  }

  Future<List<LayerMaterial>> getLayerMaterials() async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;

    result = await db.query("main_layermaterial");

    List<LayerMaterial> layerMaterials = [];

    for (var layerMaterialJson in result) {
      layerMaterials.add(LayerMaterial.fromDatabaseJson(layerMaterialJson));
    }

    return layerMaterials;
  }

  Future<void> addLayer(Layer layer) async {
    final db = await dbProvider.database;

    var layerMaterialId = await db.query("main_layermaterial", where: "name=?", whereArgs: [layer.layerMaterial.name]);
    layer.layerMaterial.id = int.parse(layerMaterialId.first['id'].toString());

    var layerDatabaseJson = layer.toDatabaseJson(layer);

    int lastId = await db.insert("main_layer", layerDatabaseJson);
  }

  Future<Layer?> getLayerById(int id) {
    throw Error();
  }

  Future<void> addLayerMaterialFromApi(LayerMaterial layerMaterial) async {
    final db = await dbProvider.database;

    var layerDatabaseJson = layerMaterial.toDatabaseJson(layerMaterial);

    var layerMaterialExists = await db.query("main_layermaterial", where: "id=? AND name=?", whereArgs: [layerMaterial.id, layerMaterial.name]);

    if (layerMaterialExists.isEmpty){
      int lastId = await db.insert("main_layermaterial", layerDatabaseJson);
    }
  }
}
