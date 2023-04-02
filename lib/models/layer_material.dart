class LayerMaterial {
  late int id;
  late String name;

  LayerMaterial();

  factory LayerMaterial.fromJson(Map<dynamic, dynamic> data) {
    LayerMaterial layerMaterial = LayerMaterial();
    layerMaterial.id = data['id'];
    layerMaterial.name = data['name'];  

    return layerMaterial;
  }

  Map<String, dynamic> toDatabaseJson(LayerMaterial layerMaterial) {
    var databaseJson = {
      'id': layerMaterial.id,
      'name': layerMaterial.name,
      'created_at': DateTime.now().toString(),
      'updated_at': DateTime.now().toString(),
    };

    return databaseJson;
  }
  
  factory LayerMaterial.fromDatabaseJson(Map<dynamic, dynamic> data) {
    LayerMaterial layerMaterial = LayerMaterial();
    layerMaterial.id = data['id'];
    layerMaterial.name = data['name'];

    return layerMaterial;
  }
}
