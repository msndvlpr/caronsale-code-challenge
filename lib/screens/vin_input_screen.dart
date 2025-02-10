import 'dart:convert';
import 'dart:async';
import 'package:caronsale_code_challenge/models/vehicle_option.dart';
import 'package:caronsale_code_challenge/services/cos_challenge.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../services/api_service.dart';
import '../models/auction_data.dart';
import '../services/storage_service.dart';
import 'vehicle_selection_screen.dart';
import 'auction_details_screen.dart';

class VinInputScreen extends StatefulWidget {
  final String userId;
  const VinInputScreen({super.key, required this.userId});

  @override
  State<VinInputScreen> createState() => _VinInputScreenState();
}

class _VinInputScreenState extends State<VinInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vinController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final vin = _vinController.text.trim();

    try {
      final result = await ApiService.fetchAuctionData(
        vin: vin,
        userId: widget.userId,
      );

      // Handle response based on type:
      if (result is AuctionData) {
        // Save auction data locally (see Step 4 below)
        // Then navigate to auction details screen
        await StorageService.saveAuctionData(result.toJson());
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => AuctionDetailsScreen(auctionData: result),
        ));
      } else if (result is List) {
        // This is a list of vehicle options from a 300 response
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => VehicleSelectionScreen(vehicleOptions: result as List<VehicleOption>, userId: widget.userId),
        ));
      }
    } on TimeoutException catch (e) {
      setState(() {
        _errorMessage = 'Request timed out. Please try again.';
      });
    } on ClientException catch (e) {
      setState(() {
        _errorMessage = 'Authentication error: ${e.message}';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? _validateVin(String? value) {
    if (value == null || value.trim().length != CosChallenge.vinLength) {
      return 'VIN must be exactly 17 characters.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Vehicle VIN')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _vinController,
                decoration: const InputDecoration(
                  labelText: 'Enter VIN',
                ),
                validator: _validateVin,
              ),
              const SizedBox(height: 20),
              if (_errorMessage != null) ...[
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 20),
              ],
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _submit, child: const Text('Fetch Data')),
            ],
          ),
        ),
      ),
    );
  }
}
