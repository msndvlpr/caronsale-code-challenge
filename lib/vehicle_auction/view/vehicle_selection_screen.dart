import 'package:auction_repository/auction_repository.dart';
import 'package:caronsale_code_challenge/vehicle_auction/bloc/auction_data_bloc.dart';
import 'package:caronsale_code_challenge/vehicle_auction/model/auction_data_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_api/network_api_service.dart';

import 'auction_details_screen.dart';

class AuctionVehicleSelectionScreen extends StatelessWidget {
  final VehicleOptionItems vehicleOptions;

  const AuctionVehicleSelectionScreen({super.key, required this.vehicleOptions});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                AuctionDataBloc(context.read<AuctionRepository>())),
      ],
      child: AuctionVehicleSelection(options: vehicleOptions),
    );
  }
}

class AuctionVehicleSelection extends StatelessWidget {
  final VehicleOptionItems options;

  const AuctionVehicleSelection({super.key, required this.options});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select the Correct Vehicle')),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuctionDataBloc, AuctionDataState>(
            listener: (context, state) {
              if (state is AuctionDataStateSuccess) {
                final uiData = AuctionDataEntity.fromAuctionData(state.auctionData, locale: 'de_DE');
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) => AuctionVehicleDetailsScreen(auctionDataEntity: uiData)));

              } else if (state is AuctionDataStateMultipleChoice) {
                final errorMessage = 'An error has occurred, please try again in a moment.';
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));

              } else if (state is AuctionDataStateFailure) {
                final errorMessage = 'A ${state.errorResponse.msgKey} error occurred: ${state.errorResponse.message}';
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));

              } else if (state is AuctionDataStateException) {
                final errorMessage = state.errorMessage;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
              }
            },
          ),
        ],
        child: BlocBuilder<AuctionDataBloc, AuctionDataState>(
          builder: (context, state) {

            if (state is AuctionDataStateLoading) {
              return Center(child: CircularProgressIndicator());

            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: options.items.length,
                  itemBuilder: (context, index) {
                    final vehicle = options.items[index];
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Icon(Icons.arrow_forward_ios_rounded, size: 16,),
                          trailing: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: vehicle.similarity / 100,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                strokeWidth: 6,
                              ),
                              Text("${vehicle.similarity.toInt()}%", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          title: Text('${vehicle.make} ${vehicle.model}'),
                          subtitle: Text(vehicle.containerName),
                          onTap: () {
                            _onVehicleSelected(context, vehicle.externalId);
                          },
                        ),
                      ),
                    );
                  },
                ),
              );

            }
          },
        ),
      ),
    );
  }

  _onVehicleSelected(BuildContext context, String eid) {
    context.read<AuctionDataBloc>().add(VehicleDataFetched(eid: eid));
  }
}
