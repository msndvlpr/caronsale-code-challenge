import 'package:caronsale_code_challenge/vehicle_auction/bloc/auction_data_bloc.dart';
import 'package:caronsale_code_challenge/vehicle_auction/model/auction_data_entity.dart';
import 'package:caronsale_code_challenge/vehicle_auction/model/vehicle_options_entity.dart';
import 'package:caronsale_code_challenge/vehicle_auction/view/auction_details_screen.dart';
import 'package:caronsale_code_challenge/vehicle_search/widget/bottom_nav_bar.dart';
import 'package:caronsale_code_challenge/vehicle_search/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleSelectionScreen extends StatelessWidget {
  final VehicleOptionsEntity vehicleOptionsEntity;

  const VehicleSelectionScreen({super.key, required this.vehicleOptionsEntity});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(title: 'Vehicle Selection'),
      bottomNavigationBar: BottomNavBar(),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuctionDataBloc, AuctionDataState>(
            listener: (context, state) {
              if (!context.mounted) return;

              if (state is AuctionDataStateSuccess) {
                ScaffoldMessenger.of(context).clearSnackBars();
                final auctionDataEntity = AuctionDataEntity.fromAuctionData(state.auctionData, locale: 'de_DE');
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => AuctionVehicleDetailsScreen(auctionDataEntity: auctionDataEntity)));

              } else if (state is AuctionDataStateMultipleChoice) {
                final errorMessage = 'An error has occurred, please try again shortly.';
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
                        itemCount: vehicleOptionsEntity.items.length,
                        itemBuilder: (context, index) {
                          final vehicle = vehicleOptionsEntity.items[index];
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
                                  Expanded(child: Text(vehicle.name, overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: true)),
                                ],
                              ),
                              onTap: () {
                                _onVehicleSelected(context, vehicle.id);
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
