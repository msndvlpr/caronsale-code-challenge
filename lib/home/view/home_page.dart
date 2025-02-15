import 'package:auction_repository/auction_repository.dart';
import 'package:caronsale_code_challenge/home/widget/home_tab_button.dart';
import 'package:caronsale_code_challenge/user_authentication/view/user_authentication_screen.dart';
import 'package:caronsale_code_challenge/vehicle_auction/model/auction_data_entity.dart';
import 'package:caronsale_code_challenge/vehicle_auction/view/auction_details_screen.dart';
import 'package:caronsale_code_challenge/vehicle_auction/view/vehicle_lookup_screen.dart';
import 'package:caronsale_code_challenge/vehicle_auction/view/vehicle_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_api/network_api_service.dart';
import 'package:secure_storage_repository/secure_storage_repository.dart';

import '../../vehicle_auction/bloc/auction_data_bloc.dart';
import '../cubit/home_cubit.dart';
import '../widget/custom_switch.dart';

class HomePage extends StatelessWidget {

  final int screen;
  final dynamic data;
  const HomePage({super.key, required this.screen, this.data});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (context) => AuctionDataBloc(context.read<AuctionRepository>()))
      ],
      child: HomeView(screen: screen, data: data),
    );
  }
}

//final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class HomeView extends StatefulWidget {

  int screen;
  dynamic data;
  HomeView({super.key, required this.screen, required this.data});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  Widget build(BuildContext context) {

    final selectedTab = context.select((HomeCubit cubit) => cubit.state.selectedTab);
    final isDark = context.select((HomeCubit cubit) => cubit.state.isDark);

    return MaterialApp(
      //navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: isDark ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: Container(
            margin: const EdgeInsets.only(top: 24),
            child: AppBar(backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              elevation: 12,
              leading: IconButton(onPressed: (){_handlePackPress(widget.screen, context);}, icon: Icon(Icons.arrow_back)),
              /*PopupMenuButton<String>(//todo
                icon: const Icon(Icons.more_horiz_rounded, size: 32),
                onSelected: (value){
                  if(value == "logout"){
                    //_confirmLogout();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        const Text('Logout'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'about',
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        const Text('About'),
                      ],
                    ),
                  ),
                ],
              ),*/
              title: _getPageTitle(widget.screen),
              centerTitle: false,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: CustomSwitch(
                    value: isDark,
                    onChanged: (value) {
                      context.read<HomeCubit>().setTheme(value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: _showScreenView(widget.screen, widget.data),
        bottomNavigationBar: BottomAppBar(color: Theme.of(context).bottomAppBarTheme.color,
          elevation: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HomeTabButton(
                groupValue: selectedTab,
                value: HomeTab.homeTab,
                icon: const Icon(Icons.home),
                label: 'Home',
              ),
              HomeTabButton(
                groupValue: selectedTab,
                value: HomeTab.profileTab,
                icon: const Icon(Icons.supervised_user_circle_outlined),
                label: 'Profile',
              ),
              HomeTabButton(
                groupValue: selectedTab,
                value: HomeTab.settingsTab,
                icon: const Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ),

      ),
    );
  }

  //todo
  /*void _confirmLogout() {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text('Logout'),
            onPressed: () async{
              final secureStorageRepository = context.read<SecureStorageRepository>();
              secureStorageRepository.clearAll();
              Navigator.of(context).popUntil((route) => route.isFirst);
              //Navigator.of(navigatorKey.currentContext!).pushReplacement(MaterialPageRoute(builder: (context) => UserAuthenticationScreen()));
            },
          ),
        ],
      ),
    );
  }*/

  Widget _getPageTitle(int screenNumber){
    if(screenNumber == 0){
      return Text('Vehicle Search', style: TextStyle(fontWeight: FontWeight.bold));
    } else if(screenNumber == 1){
      return Text('Vehicle Selection', style: TextStyle(fontWeight: FontWeight.bold));
    } else {
      return Text('Vehicle Details', style: TextStyle(fontWeight: FontWeight.bold));
    }
  }

  Widget _showScreenView(int screenNumber, dynamic data) {
    if(screenNumber == 0){
      return VehicleLookupScreen();
    } else if(screenNumber == 1){
      return AuctionVehicleSelection(vehicleOptionItems: data as VehicleOptionItems);
    } else {
      return AuctionVehicleDetailsScreen(auctionDataEntity: data as AuctionDataEntity);
    }
  }

  void _handlePackPress(int screenNumber, BuildContext context) {
    if(screenNumber == 0){
      SystemNavigator.pop();
    } else if(screenNumber == 1){
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      // Read data from cache
      final state = context.read<AuctionDataBloc>().state;
      if (state is AuctionDataStateSuccess) {
        final uiData = AuctionDataEntity.fromAuctionData(state.auctionData, locale: 'de_DE');
        setState(() {
          widget.screen = 1;
          widget.data = uiData;
        });
      }

    }
  }

}
