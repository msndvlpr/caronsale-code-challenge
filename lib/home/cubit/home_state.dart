part of 'home_cubit.dart';

enum HomeTab { homeTab, profileTab, settingsTab }

final class HomeState extends Equatable {
  const HomeState({
    this.selectedTab = HomeTab.homeTab,
    this.isDark = false,
    this.isCacheCleared = false,
  });

  final HomeTab selectedTab;
  final bool isDark;
  final bool isCacheCleared;

  @override
  List<Object> get props => [selectedTab, isDark, isCacheCleared];
}