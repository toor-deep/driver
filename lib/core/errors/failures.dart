import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  String? message;

  Failure({this.message});
}

// ignore: must_be_immutable
class ServerFailure extends Failure {
  ServerFailure({super.message}) {}

  @override
  List<Object?> get props => [];
}

class GenericFailure extends Failure {
  GenericFailure({super.message}) {}

  @override
  List<Object?> get props => [];
}

class CacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class UserNotFound extends CacheFailure {}
