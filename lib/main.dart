import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/identification_screen.dart';
import 'screens/vin_input_screen.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized before any async work.
  WidgetsFlutterBinding.ensureInitialized();

  // Attempt to get a previously saved userId.
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userId = prefs.getString('userId');

  // Start the app and decide which screen to show first.
  runApp(MyApp(initialUserId: userId));
}

class MyApp extends StatelessWidget {
  final String? initialUserId;

  const MyApp({Key? key, required this.initialUserId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarOnSale Flutter Challenge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // If a userId exists, start with the VIN input screen;
      // otherwise, show the identification screen.
      home: initialUserId == null
          ? const IdentificationScreen()
          : VinInputScreen(userId: initialUserId!),
      // Optionally, you can define named routes if your app grows in complexity.
      routes: {
        '/identification': (context) => const IdentificationScreen(),
        '/vin': (context) =>
            VinInputScreen(userId: initialUserId ?? 'defaultUserId'),
        // Other routes can be added here.
      },
    );
  }
}
