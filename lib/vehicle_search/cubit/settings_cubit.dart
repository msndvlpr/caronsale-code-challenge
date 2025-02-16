import 'package:bloc/bloc.dart';
import 'package:caronsale_code_challenge/vehicle_search/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:secure_storage_repository/secure_storage_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SecureStorageRepository _secureStorageRepository;

  SettingsCubit({SecureStorageRepository? secureStorageRepository})
      : _secureStorageRepository = secureStorageRepository ?? SecureStorageRepository(),
        super(const SettingsState());

  void setUseCache(bool useCache) {
    emit(SettingsState(useCache: useCache));
    _secureStorageRepository.write(storageKeyUseCache, useCache.toString());
  }
}
