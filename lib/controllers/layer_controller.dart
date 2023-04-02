import 'package:flutter_application_1/models/layer.dart';
import 'package:flutter_application_1/models/layer_material.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/models/well.dart';
import 'package:flutter_application_1/repository/layer_repository.dart';
import 'package:flutter_application_1/services/storage_service.dart';

class LayerController {
  LayerRepository _layerRepo = LayerRepository();

  Future<void> getLayerMaterialsFromApi() async {
    return await _layerRepo.getLayerMaterialsFromApi();
  }

  Future<List<Layer>> getLayers(int wellId) async {
    return await _layerRepo.getLayers(wellId);
  }

  Future<List<LayerMaterial>> getLayerMaterials() async {
    return await _layerRepo.getLayerMaterials();
  }

  Future<void> addLayer(
    int wellId, String name, String description, String material, String comment, bool sampleObtained, bool aquifer, bool drillingStopped
  ) async {
    
    return await _layerRepo.addLayer(wellId, name, description, material, comment, sampleObtained, aquifer, drillingStopped);
  }
}
