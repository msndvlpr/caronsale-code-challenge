import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  //todo
  /*void setTab(HomeTab tab) =>
      emit(HomeState(selectedTab: tab, isDark: state.isDark));*/

  void setTheme(bool? isDark) => emit(HomeState(
      selectedTab: state.selectedTab, isDark: isDark ?? state.isDark));

  /*void setDataCacheState(bool isCleared) =>
      emit(HomeState(isCacheCleared: isCleared, isDark: state.isDark));*/
}
