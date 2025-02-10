import 'package:flutter/material.dart';
import '../models/auction_data.dart';

class AuctionDetailsScreen extends StatelessWidget {
  final AuctionData auctionData;
  const AuctionDetailsScreen({Key? key, required this.auctionData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auction Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Model: ${auctionData.model}', style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 10),
                Text('Price: €${auctionData.price}'),
                const SizedBox(height: 10),
                Text('Auction UUID: ${auctionData.fkUuidAuction}'),
                const SizedBox(height: 10),
                Text('Feedback: ${auctionData.feedback}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
