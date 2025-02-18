import 'package:bloc/bloc.dart';
import 'package:caronsale_code_challenge/vehicle_search/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:secure_storage_api/secure_storage_api.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SecureStorageApi _secureStorageApi;

  SettingsCubit({SecureStorageApi? secureStorageApi})
      : _secureStorageApi = secureStorageApi ?? SecureStorageApi(),
        super(const SettingsState());

  void setUseCache(bool useCache) {
    emit(SettingsState(useCache: useCache));
    _secureStorageApi.write(storageKeyUseCache, useCache.toString());
  }
}
