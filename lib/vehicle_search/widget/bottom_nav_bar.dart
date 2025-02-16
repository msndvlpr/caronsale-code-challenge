import 'package:caronsale_code_challenge/vehicle_search/widget/home_tab_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});


  @override
  Widget build(BuildContext context) {
    return BottomAppBar(color: Theme
        .of(context)
        .bottomAppBarTheme
        .color,
      elevation: 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          HomeTabButton(
            selected: true,
            icon: const Icon(Icons.home),
            label: 'Home',
          ),
          HomeTabButton(
            selected: false,
            icon: const Icon(Icons.supervised_user_circle_outlined),
            label: 'Profile',
          ),
          HomeTabButton(
            selected: false,
            icon: const Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }


}