part of 'progress_cubit.dart';

abstract class ProgressState {}

class ProgressInitial extends ProgressState {}

class ProgressLoading extends ProgressState {}

class ProgressLoaded extends ProgressState {
  final ProgressModel progressData;

  ProgressLoaded(this.progressData);
}

class ProgressError extends ProgressState {
  final String message;

  ProgressError(this.message);
}
