import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home_cubit.dart';

class HomeTabButton extends StatelessWidget {
  const HomeTabButton({
    super.key,
    required this.groupValue,
    required this.value,
    required this.icon,
    required this.label,
  });

  final HomeTab groupValue;
  final HomeTab value;
  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = groupValue == value;
    final Color activeColor = Theme.of(context).colorScheme.primary;
    final Color inactiveColor = Colors.grey.shade600;

    return TextButton(
      onPressed: () {
        context.read<HomeCubit>().setTab(value);
      },
      style: TextButton.styleFrom(
        foregroundColor: isSelected ? activeColor : inactiveColor,
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconTheme(
            data: IconThemeData(
              size: 26,
              color: isSelected ? activeColor : inactiveColor,
            ),
            child: icon,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? activeColor : inactiveColor,
              fontSize: isSelected ? 12 : 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
