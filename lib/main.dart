import 'dart:developer';
import 'dart:ui';

import 'package:auction_repository/auction_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:secure_storage_repository/secure_storage_repository.dart';

import 'app/app.dart';
import 'app/app_bloc_observer.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('de_DE', null);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    log(error.toString(), stackTrace: stack);
    return true;
  };

  Bloc.observer = const AppBlocObserver();

  final auctionRepository = AuctionRepository();
  final authenticationRepository = AuthenticationRepository();
  final secureStorageRepository = SecureStorageRepository();

  runApp(App(
      auctionRepository: auctionRepository,
      authenticationRepository: authenticationRepository,
      secureStorageRepository: secureStorageRepository));
}
