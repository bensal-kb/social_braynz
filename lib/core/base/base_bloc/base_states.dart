import 'package:equatable/equatable.dart';

import '../../errors/app_error.dart';

enum Status { initial, loading, success, error }

abstract class BaseState extends Equatable {
  const BaseState({this.state = Status.initial, this.error});

  final Status state;
  final AppError? error;

  bool get isInitial => state == Status.initial;
  bool get isLoading => state == Status.loading;
  bool get isSuccess => state == Status.success;
  bool get isError => state == Status.error;

  T cast<T>() => this as T;
}
