part of 'user_auth_bloc.dart';

sealed class UserAuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserAuthDataStateInitial extends UserAuthState {}

class UserAuthDataStateLoading extends UserAuthState {}

class UserAuthDataStateSuccess extends UserAuthState {
  final String token;

  UserAuthDataStateSuccess({required this.token});

  @override
  List<Object?> get props => [token];
}

class UserAuthDataStateFailure extends UserAuthState {
  final String errorMessage;

  UserAuthDataStateFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
