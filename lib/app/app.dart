import 'package:auction_repository/auction_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:authentication_repository/src/constants.dart' as keys;
import 'package:caronsale_code_challenge/user_authentication/view/user_authentication_screen.dart';
import 'package:caronsale_code_challenge/vehicle_auction/bloc/auction_data_bloc.dart';
import 'package:caronsale_code_challenge/vehicle_search/cubit/settings_cubit.dart';
import 'package:caronsale_code_challenge/vehicle_search/cubit/theme_cubit.dart';
import 'package:caronsale_code_challenge/vehicle_search/view/vehicle_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage_api/secure_storage_api.dart';

import '../user_authentication/bloc/user_auth_bloc.dart';

class App extends StatelessWidget {

  final AuctionRepository auctionRepository;
  final AuthenticationRepository authenticationRepository;
  final SecureStorageApi secureStorageApi;

  const App(
      {required this.auctionRepository,
      required this.authenticationRepository,
      required this.secureStorageApi,
      super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuctionRepository>.value(value: auctionRepository),
        RepositoryProvider<AuthenticationRepository>.value(value: authenticationRepository),
        RepositoryProvider<SecureStorageApi>.value(value: secureStorageApi),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => UserAuthBloc(context.read<AuthenticationRepository>())),
          BlocProvider(create: (context) => AuctionDataBloc(context.read<AuctionRepository>())),
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(create: (_) => SettingsCubit()),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {

    final secureStorageApi = context.read<SecureStorageApi>();

    return BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state)
    {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: state.isDark ? ThemeData.dark() : ThemeData.light(),
        home: FutureBuilder<bool>(
          future: _isUserAuthenticated(secureStorageApi),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return (snapshot.data ?? false)
                  ? VehicleSearchScreen()
                  : UserAuthenticationScreen();
            } else {
              return Container(color: Colors.white,
                child: Center(
                    child: CircularProgressIndicator(color: Theme
                        .of(context)
                        .colorScheme
                        .primary)),
              );
            }
          },
        ),
      );
    });

  }

  Future<bool> _isUserAuthenticated(SecureStorageApi secureStorageApi) async {
    final token = await secureStorageApi.read(keys.storageKeyToken);
    return token != null && token.isNotEmpty;
  }
}
