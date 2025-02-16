
import 'package:network_api/network_api_service.dart';

class VehicleOptionsEntity {
  final List<VehicleOptionEntity> items;

  VehicleOptionsEntity({required this.items});

  // Convert from the repository layer `VehicleOptionItems` model
  factory VehicleOptionsEntity.fromVehicleOptions(VehicleOptionItems model) {
    return VehicleOptionsEntity(
      items: model.items.map((item) => VehicleOptionEntity.fromVehicleOption(item)).toList(),
    );
  }
}

class VehicleOptionEntity {
  final String make;
  final String model;
  final String name;
  final int similarity;
  final String id;

  VehicleOptionEntity({
    required this.make,
    required this.model,
    required this.name,
    required this.similarity,
    required this.id,
  });

  // Converts from repository model to UI entity
  factory VehicleOptionEntity.fromVehicleOption(VehicleOption model) {
    return VehicleOptionEntity(
      make: model.make,
      model: model.model,
      name: model.containerName,
      similarity: model.similarity,
      id: model.externalId,
    );
  }

}