part of 'authentication_bloc.dart';

abstract class AuthState {}

class UserUnauthorized extends AuthState {}

class UserAuthLoadingState extends AuthState {} //طالما في Future

class UserAuthorizedState extends AuthState {}

class UserAnonymousState extends AuthState {}

class UserErrorState extends AuthState {
  final String error;

  UserErrorState({required this.error});
}