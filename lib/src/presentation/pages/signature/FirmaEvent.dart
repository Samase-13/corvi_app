// FirmaEvent.dart
abstract class FirmaEvent {}

class EnviarCodigo extends FirmaEvent {}

class ValidarCodigo extends FirmaEvent {
  final String codigoIngresado;
  ValidarCodigo(this.codigoIngresado);
}

class InvalidarCodigo extends FirmaEvent {}
