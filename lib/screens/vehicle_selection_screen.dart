import 'package:flutter/material.dart';
import '../models/vehicle_option.dart';
import 'auction_details_screen.dart';
import '../services/api_service.dart';

class VehicleSelectionScreen extends StatelessWidget {
  final List<VehicleOption> vehicleOptions;
  final String userId;
  const VehicleSelectionScreen({super.key, required this.vehicleOptions, required this.userId});

  void _onVehicleSelected(BuildContext context, VehicleOption selectedOption) {
    // You might want to re-fetch auction data using the selected vehicle's externalId,
    // or simply pass the chosen vehicle option to the next screen.
    // For demonstration, we simulate converting the option into AuctionData.
    // Alternatively, call a new API request using selectedOption.externalId.
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => AuctionDetailsScreen(
        auctionData: selectedOption.toAuctionData(),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select the Correct Vehicle')),
      body: ListView.builder(
        itemCount: vehicleOptions.length,
        itemBuilder: (context, index) {
          final option = vehicleOptions[index];
          return Card(
            child: ListTile(
              title: Text('${option.make} ${option.model}'),
              subtitle: Text('${option.containerName}\nSimilarity: ${option.similarity}'),
              onTap: () => _onVehicleSelected(context, option),
            ),
          );
        },
      ),
    );
  }
}
