import 'package:auction_repository/auction_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:caronsale_code_challenge/home/view/home_page.dart';
import 'package:caronsale_code_challenge/user_authentication/view/user_authentication_screen.dart';
import 'package:caronsale_code_challenge/vehicle_auction/view/vehicle_lookup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage_repository/secure_storage_repository.dart';

import '../user_authentication/bloc/user_auth_bloc.dart';

class App extends StatelessWidget {
  final AuctionRepository auctionRepository;
  final AuthenticationRepository authenticationRepository;
  final SecureStorageRepository secureStorageRepository;

  const App(
      {required this.auctionRepository,
      required this.authenticationRepository,
      required this.secureStorageRepository,
      super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuctionRepository>.value(value: auctionRepository),
        RepositoryProvider<AuthenticationRepository>.value(value: authenticationRepository),
        RepositoryProvider<SecureStorageRepository>.value(value: secureStorageRepository),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final secureStorageRepository = context.read<SecureStorageRepository>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => UserAuthBloc(context.read<AuthenticationRepository>())),
          ], child: FutureBuilder<bool>(
        future: _isUserAuthenticated(secureStorageRepository),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return (snapshot.data ?? false) ? const HomePage(screen: 0) : const UserAuthenticationScreen();
          } else {
            return Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary));
          }
        },
      )),
    );
  }

  Future<bool> _isUserAuthenticated(SecureStorageRepository secureStorageRepository) async {
    final token = await secureStorageRepository.read(storageKeyToken);
    return token != null && token.isNotEmpty;
  }
}
