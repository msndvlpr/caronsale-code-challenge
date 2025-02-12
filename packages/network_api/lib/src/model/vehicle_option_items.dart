import 'dart:convert';

class VehicleOptionItems {
  final List<VehicleOption> items;

  VehicleOptionItems({required this.items});

  factory VehicleOptionItems.fromJson(String jsonString) {
    List<dynamic> jsonList = jsonDecode(jsonString);
    List<VehicleOption> vehicleOptions = jsonList.map((json) => VehicleOption.fromJson(json)).toList();
    // Sort the items based on similarity to show higher similarities on top of the list
    vehicleOptions.sort((a, b) => b.similarity.compareTo(a.similarity));
    return VehicleOptionItems(items: vehicleOptions);
  }

  String toJson() {
    return jsonEncode(items.map((item) => item.toJson()).toList());
  }
}

class VehicleOption {
  final String make;
  final String model;
  final String containerName;
  final int similarity;
  final String externalId;

  VehicleOption({
    required this.make,
    required this.model,
    required this.containerName,
    required this.similarity,
    required this.externalId,
  });

  factory VehicleOption.fromJson(Map<String, dynamic> json) => VehicleOption(
    make: json["make"],
    model: json["model"],
    containerName: json["containerName"],
    similarity: json["similarity"],
    externalId: json["externalId"],
  );

  Map<String, dynamic> toJson() => {
    "make": make,
    "model": model,
    "containerName": containerName,
    "similarity": similarity,
    "externalId": externalId,
  };
}
