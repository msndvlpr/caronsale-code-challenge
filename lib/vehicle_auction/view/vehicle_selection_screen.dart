import 'package:auction_repository/auction_repository.dart';
import 'package:caronsale_code_challenge/home/view/home_page.dart';
import 'package:caronsale_code_challenge/vehicle_auction/bloc/auction_data_bloc.dart';
import 'package:caronsale_code_challenge/vehicle_auction/model/auction_data_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_api/network_api_service.dart';

class AuctionVehicleSelectionScreen extends StatelessWidget {
  final VehicleOptionItems vehicleOptions;

  const AuctionVehicleSelectionScreen({super.key, required this.vehicleOptions});

  @override
  Widget build(BuildContext context) {
    return AuctionVehicleSelection(vehicleOptionItems: vehicleOptions);
  }
}

class AuctionVehicleSelection extends StatelessWidget {
  final VehicleOptionItems vehicleOptionItems;

  const AuctionVehicleSelection({super.key, required this.vehicleOptionItems});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuctionDataBloc, AuctionDataState>(
            listener: (context, state) {
              if (state is AuctionDataStateSuccess) {
                final uiData = AuctionDataEntity.fromAuctionData(state.auctionData, locale: 'de_DE');
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) => HomePage(screen: 2, data: uiData)));

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
              return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));

            } else {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 32, bottom: 24, right: 20, left: 20),
                    child: Text("Higher similarity means a stronger match. Select a vehicle to view auction details.", style: Theme.of(context).textTheme.bodyMedium),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: vehicleOptionItems.items.length,
                        itemBuilder: (context, index) {
                          final vehicle = vehicleOptionItems.items[index];
                          return Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: Icon(Icons.arrow_forward_ios_rounded, size: 16,),
                              trailing: Column(
                                children: [
                                  Text('similarity', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300)),
                                  SizedBox(height: 4),
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        value: vehicle.similarity / 100,
                                        backgroundColor: Colors.grey[300],
                                        valueColor: AlwaysStoppedAnimation<Color>(isDark ? theme.colorScheme.inversePrimary : theme.colorScheme.primary),
                                        strokeWidth: 6,
                                      ),
                                      Text("${vehicle.similarity.toInt()}%", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                              title: Padding(
                                padding: const EdgeInsets.only(top: 16, bottom: 20),
                                child: Text('${vehicle.make} ${vehicle.model}'),
                              ),
                              subtitle: Row(
                                children: [
                                  Expanded(child: Text(vehicle.containerName, overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: true)),
                                ],
                              ),
                              onTap: () {
                                _onVehicleSelected(context, vehicle.externalId);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
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
