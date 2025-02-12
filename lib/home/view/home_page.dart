import 'package:caronsale_code_challenge/home/widget/home_tab_button.dart';
import 'package:caronsale_code_challenge/identification/view/user_identification_screen.dart';
import 'package:caronsale_code_challenge/auction/view/vehicle_lookup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home_cubit.dart';
import '../widget/custom_switch.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const HomeView(),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {

    final selectedTab = context.select((HomeCubit cubit) => cubit.state.selectedTab);
    final isDark = context.select((HomeCubit cubit) => cubit.state.isDark);

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: isDark ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: Container(
            margin: const EdgeInsets.only(top: 24),
            child: AppBar(backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              elevation: 12,
              leading: PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz_rounded, size: 32),
                onSelected: (value){

                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(Icons.share, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        const Text('Share'),
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
              ),
              title: const Text(
                'Energy Monitoring',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
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
        body: VehicleLookupScreen(),
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

}
