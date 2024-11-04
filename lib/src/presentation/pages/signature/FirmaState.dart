abstract class FirmaState {}

class FirmaInicial extends FirmaState {}

class FirmaCodigoEnviando extends FirmaState {}

class FirmaCodigoEnviado extends FirmaState {}

class FirmaEsperandoCodigo extends FirmaState {}

class FirmaCodigoValidado extends FirmaState {}

class FirmaError extends FirmaState {
  final String message;
  FirmaError(this.message);
}