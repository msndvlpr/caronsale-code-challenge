import 'package:caronsale_code_challenge/home/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auction/view/vehicle_lookup_screen.dart';

class UserIdentificationScreen extends StatefulWidget {
  const UserIdentificationScreen({super.key});

  @override
  State<UserIdentificationScreen> createState() => _UserIdentificationScreenState();
}

class _UserIdentificationScreenState extends State<UserIdentificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userIdController = TextEditingController();

  Future<void> _saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  void _submit(BuildContext con) {
    if (_formKey.currentState!.validate()) {
      final userId = _userIdController.text.trim();
      //await _saveUserId(userId);
      // Navigate to the VIN input screen
      Navigator.of(con).push(MaterialPageRoute(builder: (_) => HomePage())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('User Identification')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _userIdController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your unique User ID',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a valid User ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: () {_submit(context);}, child: const Text('Continue')),
              ],
            ),
          ),
        ),
      );
  }
}
