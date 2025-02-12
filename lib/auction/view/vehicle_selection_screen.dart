/*import 'package:flutter/material.dart';
import 'package:network_api/network_api_service.dart';

import 'auction_details_screen.dart';

class VehicleSelectionScreen extends StatelessWidget {

  final VehicleOptionItems vehicleOptions;
  const VehicleSelectionScreen({super.key, required this.vehicleOptions});

  void _onVehicleSelected(BuildContext context, VehicleOption selectedOption) {
    // You might want to re-fetch auction data using the selected vehicle's externalId,
    // or simply pass the chosen vehicle option to the next screen.
    // For demonstration, we simulate converting the option into AuctionData.
    // Alternatively, call a new API request using selectedOption.externalId.

    /*Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => AuctionDetailsScreen(auctionData: null)
    ));*/
  }

  // todo
  // sort based on similarity and show indicator for sim number
  // upon pressing an item fetch another API call and then navigate to Auction screen with AuctionData
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select the Correct Vehicle')),
      body: ListView.builder(
        itemCount: vehicleOptions.items.length,
        itemBuilder: (context, index) {
          final option = vehicleOptions.items[index];
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
}*/

import 'package:auction_repository/auction_repository.dart';
import 'package:caronsale_code_challenge/auction/bloc/auction_data_bloc.dart';
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
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) =>
                        AuctionVehicleDetailsScreen(auctionData: state.auctionData)));

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
                      child: ListTile(
                        title: Text('${vehicle.make} ${vehicle.model}'),
                        subtitle: Text('${vehicle.containerName}\nSimilarity: ${vehicle.similarity}'),
                        onTap: () {
                          _onVehicleSelected(context, vehicle.externalId);
                        },
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
