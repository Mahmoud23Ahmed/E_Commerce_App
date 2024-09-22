import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class ServerFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class OfflineFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class EmptyCacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class EmptyListFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class EmailAlreadyExistFailer extends Failure{
  @override
  List<Object?> get props => [];
}
class UserNotFoundFailure extends Failure{
  @override
  List<Object?> get props => [];
}
class WrongPasswordFailure extends Failure{
  @override
  List<Object?> get props => [];
}
class WrongEmailFailure extends Failure{
  @override
  List<Object?> get props => [];
}
class FailureWhileSignIn extends Failure{
  @override
  List<Object?> get props => [];
}