import 'package:auction_repository/auction_repository.dart';
import 'package:caronsale_code_challenge/user_authentication/view/user_authentication_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class App extends StatelessWidget {
  final AuctionRepository auctionRepository;

  const App({required this.auctionRepository, super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: auctionRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: UserAuthenticationScreen(),
        debugShowCheckedModeBanner: false,
    );
  }
}
