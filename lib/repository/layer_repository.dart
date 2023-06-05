import 'dart:async';
import 'package:flutter_application_1/dao/layer_dao.dart';
import 'package:flutter_application_1/models/layer.dart';
import 'package:flutter_application_1/models/layer_material.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/models/well.dart';
import 'package:flutter_application_1/repository/layer_interface.dart';
import 'package:flutter_application_1/services/storage_service.dart';

import 'package:flutter_application_1/models/api_models.dart';
import 'package:flutter_application_1/api_connection/api_connection.dart';

class LayerRepository implements ILayerRepository {
  final layerDao = LayerDao();

  LayerRepository();

  @override
  Future<List<Layer>> getLayers(int wellId) async {
    return await layerDao.getLayers(wellId);
  }

  @override
  Future<Layer> getLayer(int id) async {
    return await layerDao.getLayer(id);
  }

  @override
  Future<List<LayerMaterial>> getLayerMaterials() async {
    return await layerDao.getLayerMaterials();
  }

  @override
  Future<double> getPreviousDepth(int wellID) async {
    return await layerDao.getPreviousDepth(wellID);
  }

  @override
  Future<void> getLayerMaterialsFromApi() async {
    String? accessToken = await StorageService().readSecureData("accessToken");
    String? refreshToken = await StorageService().readSecureData("refreshToken");
    Token token = Token(token: accessToken!, refreshToken: refreshToken!);

    List<LayerMaterial> layerMaterials = await LayerService().getLayerMaterialsFromApi(token);

    for (var layerMaterial in layerMaterials) {
      layerDao.addLayerMaterialFromApi(layerMaterial);
    }
  }

  @override
  Future<void> addLayer(
    int wellId, String name, String description, String material, String comment, bool sampleObtained, bool aquifer, bool drillingStopped
  ) async {
    LayerMaterial layerMaterial = LayerMaterial();
    layerMaterial.name = material;

    var userID = await StorageService().readSecureData("userID");
    User user = User();
    user.id = int.parse(userID!);

    Well well = Well();
    well.id = wellId;

    Layer layer = Layer();
    layer.name = name;
    layer.depth = double.parse(name);
    layer.description = description;
    layer.layerMaterial = layerMaterial;
    layer.well = well;
    layer.comment = comment;
    layer.sampleObtained = sampleObtained;
    layer.drillingStopped = drillingStopped;
    layer.aquifer = aquifer;
    layer.responsible = user;

    return await layerDao.addLayer(layer);
  }

  @override
  Future<void> updateLayer(
    int id, String name, String description, String material, String comment, bool sampleObtained, bool aquifer, bool drillingStopped
  ) async {
    print("SICCCCCCHHHHHHHHHHHHHHHH");

    LayerMaterial layerMaterial = LayerMaterial();
    layerMaterial.name = material;

    var userID = await StorageService().readSecureData("userID");
    User user = User();
    user.id = int.parse(userID!);

    Layer layer = Layer();
    layer.id = id;
    layer.name = name;
    layer.depth = double.parse(name);
    layer.description = description;
    layer.layerMaterial = layerMaterial;
    layer.comment = comment;
    layer.sampleObtained = sampleObtained;
    layer.drillingStopped = drillingStopped;
    layer.aquifer = aquifer;
    layer.responsible = user;

    return await layerDao.updateLayer(layer);
  }
}
