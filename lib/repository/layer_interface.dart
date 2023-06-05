import 'package:flutter_application_1/models/layer.dart';
import 'package:flutter_application_1/models/layer_material.dart';

abstract class ILayerRepository {
  Future<List<Layer>> getLayers(int wellId);

  Future<Layer> getLayer(int id);

  Future<void> getLayerMaterialsFromApi();

  Future<List<LayerMaterial>> getLayerMaterials();

  Future<double> getPreviousDepth(int wellID);
}
