import 'package:caronsale_code_challenge/vehicle_search/cubit/settings_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CacheToggleSwitch extends StatelessWidget{

  const CacheToggleSwitch({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Theme.of(context).colorScheme.inversePrimary,
          width: 0.5,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Use Cache", style: TextStyle(fontSize: 14)),
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return Switch(padding: EdgeInsets.all(0),
                value: state.useCache,
                onChanged: (value) {
                  context.read<SettingsCubit>().setUseCache(value);
                },
              );
            }
          ),
        ],
      ),
    );
  }
}
