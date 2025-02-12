import 'package:flutter/material.dart';
import 'package:network_api/network_api_service.dart';

class AuctionVehicleDetailsScreen extends StatelessWidget {

  final AuctionData auctionData;
  const AuctionVehicleDetailsScreen({super.key, required this.auctionData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auction Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(8),
          // Set a background color for the Material widget so the splash is visible.
          color: Colors.white,
          child: InkWell(
            onTap: () {
              // Handle the tap event (for example, navigate to another screen or show a message)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Auction item tapped!')),
              );
            },
            borderRadius: BorderRadius.circular(8),
            splashColor: Colors.blue.withOpacity(0.3), // Optional: customize the splash color
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Model: ${auctionData.model}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Price: €${auctionData.price}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Auction UUID: ${auctionData.fkUuidAuction}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Feedback: ${auctionData.feedback}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
