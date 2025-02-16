part of 'settings_cubit.dart';

final class SettingsState extends Equatable {
  const SettingsState({
    this.useCache = false
  });

  final bool useCache;

  @override
  List<Object> get props => [useCache];
}