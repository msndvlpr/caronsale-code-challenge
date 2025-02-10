import 'auction_data.dart';

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

  factory VehicleOption.fromJson(Map<String, dynamic> json) {
    return VehicleOption(
      make: json['make'] as String,
      model: json['model'] as String,
      containerName: json['containerName'] as String,
      similarity: json['similarity'] as int,
      externalId: json['externalId'] as String,
    );
  }

  // Optionally, convert this option to AuctionData or trigger another fetch.
  AuctionData toAuctionData() {
    // Dummy conversion; in a real app you might call another API endpoint.
    return AuctionData(
      id: 0,
      feedback: 'No feedback available',
      valuatedAt: DateTime.now(),
      make: make,
      model: model,
      externalId: externalId,
      price: 0,
      positiveCustomerFeedback: false,
      requestedAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      fkSellerUser: 'fkSellerUser',
      fkUuidAuction: 'fkUuidAuction',
      inspectorRequestedAt: DateTime.now(),
      origin: 'origin',
      estimationRequestId: 'estimationRequestId',
    );
  }
}
