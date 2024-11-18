import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Estados
abstract class ShippingState extends Equatable {
  const ShippingState();

  @override
  List<Object?> get props => [];
}

class ShippingInitial extends ShippingState {}

class ShippingLoading extends ShippingState {}

class ShippingAddressSet extends ShippingState {
  final String destino;

  const ShippingAddressSet({required this.destino});

  @override
  List<Object?> get props => [destino];
}

// Eventos
abstract class ShippingEvent extends Equatable {
  const ShippingEvent();

  @override
  List<Object?> get props => [];
}

class SaveShippingAddressEvent extends ShippingEvent {
  final String destino;

  const SaveShippingAddressEvent({required this.destino});

  @override
  List<Object?> get props => [destino];
}

// Bloc
class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  ShippingBloc() : super(ShippingInitial()) {
    on<SaveShippingAddressEvent>(_onSaveShippingAddress);
  }

  Future<void> _onSaveShippingAddress(
      SaveShippingAddressEvent event, Emitter<ShippingState> emit) async {
    emit(ShippingLoading());
    await Future.delayed(const Duration(milliseconds: 500)); // Simulación de espera
    emit(ShippingAddressSet(destino: event.destino));
  }
}
