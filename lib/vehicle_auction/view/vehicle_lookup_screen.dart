import 'package:auction_repository/auction_repository.dart';
import 'package:caronsale_code_challenge/vehicle_auction/bloc/auction_data_bloc.dart';
import 'package:caronsale_code_challenge/vehicle_auction/view/vehicle_selection_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/data_validator.dart';
import '../model/auction_data_entity.dart';
import 'auction_details_screen.dart';

class VehicleLookupScreen extends StatelessWidget {
  const VehicleLookupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuctionDataBloc(context.read<AuctionRepository>())
        ),
      ],
      child: VehicleLookup(),
    );
  }
}

class VehicleLookup extends StatelessWidget {
  VehicleLookup({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vinController = TextEditingController();

  void _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final vin = _vinController.text.trim();
    context.read<AuctionDataBloc>().add(AuctionDataFetched(vin: vin));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuctionDataBloc, AuctionDataState>(
            listener: (context, state) {
              if (state is AuctionDataStateSuccess) {
                final uiData = AuctionDataEntity.fromAuctionData(state.auctionData, locale: 'de_DE');
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => AuctionVehicleDetailsScreen(auctionDataEntity: uiData)));

              } else if (state is AuctionDataStateMultipleChoice) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => AuctionVehicleSelectionScreen(vehicleOptions: state.vehicleOptionItems)));

              } else if (state is AuctionDataStateFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('An error occurred!')));

              } else if (state is AuctionDataStateException) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('An error occurred!')));
              }
            },
          ),
        ],
        child: BlocBuilder<AuctionDataBloc, AuctionDataState>(
          builder: (context, state) {
            String? errorMessage;
            var isLoading = false;

            if (state is AuctionDataStateFailure) {
              errorMessage = 'A ${state.errorResponse.msgKey} error occurred: ${state.errorResponse.message}';

            } else if (state is AuctionDataStateException) {
              errorMessage = state.errorMessage;

            } else if (state is AuctionDataStateLoading) {
              isLoading = true;
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _vinController,
                      decoration: const InputDecoration(labelText: 'Enter VIN'),
                      validator: isVinValid,
                    ),
                    const SizedBox(height: 20),

                    if (errorMessage != null) ...[
                      Text(errorMessage, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 20),
                    ],

                    isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: () => _submit(context),
                      child: const Text('Fetch VIN Data'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }


}