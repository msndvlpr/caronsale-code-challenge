part of 'user_auth_bloc.dart';

sealed class UserAuthEvent extends Equatable {}

class UserAuthDataFetched extends UserAuthEvent {

  final String username;
  final String password;
  UserAuthDataFetched({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}