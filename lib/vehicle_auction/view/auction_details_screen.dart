import 'package:caronsale_code_challenge/vehicle_auction/model/auction_data_entity.dart';
import 'package:caronsale_code_challenge/vehicle_auction/widget/expandable_view.dart';
import 'package:flutter/material.dart';

class AuctionVehicleDetailsScreen extends StatelessWidget {
  final AuctionDataEntity auctionDataEntity;

  const AuctionVehicleDetailsScreen(
      {super.key, required this.auctionDataEntity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auction Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(8),

            color: Colors.white,
            child: ExpandableView(model: auctionDataEntity)),
      ),
    );
  }
}
