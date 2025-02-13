import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_auth_event.dart';

part 'user_auth_state.dart';

class UserAuthBloc extends Bloc<UserAuthEvent, UserAuthState> {
  final AuthenticationRepository authenticationRepository;

  UserAuthBloc(this.authenticationRepository)
      : super(UserAuthDataStateInitial()) {
    on<UserAuthDataFetched>(_getUserAuthDataByCredentials);
  }

  void _getUserAuthDataByCredentials(UserAuthDataFetched event, Emitter<UserAuthState> emit) async {

    emit(UserAuthDataStateLoading());
    try {
      final data = await authenticationRepository.authenticateUserByCredentials(
          event.username, event.password);

      emit(UserAuthDataStateSuccess(token: data));
    } catch (e) {
      emit(UserAuthDataStateFailure(errorMessage: e.toString()));
    }
  }
}
