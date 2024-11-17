import 'package:equatable/equatable.dart';

abstract class TrackingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateTrackingEvent extends TrackingEvent {
  final String codigoRastreo;
  final String destino;

  CreateTrackingEvent(this.codigoRastreo, this.destino);

  @override
  List<Object?> get props => [codigoRastreo, destino];
}

class GetTrackingEvent extends TrackingEvent {
  final String codigoRastreo;

  GetTrackingEvent(this.codigoRastreo);

  @override
  List<Object?> get props => [codigoRastreo];
}

class UpdateTrackingEvent extends TrackingEvent {
  final String codigoRastreo;
  final String estado;
  final String observaciones;

  UpdateTrackingEvent(this.codigoRastreo, this.estado, this.observaciones);

  @override
  List<Object?> get props => [codigoRastreo, estado, observaciones];
}
