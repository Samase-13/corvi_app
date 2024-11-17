import 'package:equatable/equatable.dart';

abstract class TrackingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TrackingInitial extends TrackingState {}

class TrackingLoading extends TrackingState {}

class TrackingSuccess extends TrackingState {
  final Map<String, dynamic> trackingData;

  TrackingSuccess(this.trackingData);

  @override
  List<Object?> get props => [trackingData];
}

class TrackingFailure extends TrackingState {
  final String error;

  TrackingFailure(this.error);

  @override
  List<Object?> get props => [error];
}
