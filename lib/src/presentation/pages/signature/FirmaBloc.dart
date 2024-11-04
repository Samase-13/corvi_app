import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'FirmaEvent.dart';
import 'FirmaState.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FirmaBloc extends Bloc<FirmaEvent, FirmaState> {
  String _codigoGenerado = '';
  Timer? _temporizador;

  FirmaBloc() : super(FirmaInicial()) {
    on<EnviarCodigo>((event, emit) async {
      _codigoGenerado = _generarCodigo();
      emit(FirmaCodigoEnviando());
      await _enviarCodigoPorSms(_codigoGenerado, emit);
      _iniciarTemporizador(); // Inicia el temporizador aquí
    });

    on<ValidarCodigo>((event, emit) {
      if (event.codigoIngresado == _codigoGenerado) {
        emit(FirmaCodigoValidado());
        _detenerTemporizador();
      } else {
        emit(FirmaError('Código incorrecto o expirado.'));
      }
    });
    
    on<InvalidarCodigo>((event, emit) {
      _codigoGenerado = '';
      emit(FirmaError('Código ha expirado.'));
    });
  }

  String _generarCodigo() {
    final random = Random();
    return (random.nextInt(900000) + 100000).toString(); // Código de 6 dígitos
  }

  Future<void> _enviarCodigoPorSms(String codigo, Emitter<FirmaState> emit) async {
    final url = Uri.parse('https://api.sendinblue.com/v3/smtp/email');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'api-key': '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'
      },
      body: jsonEncode({
        'sender': {'email': 'fernandezllanoselias@gmail.com'},
        'to': [{'email': 'foxes71502@gmail.com'}],
        'subject': 'Código de validación',
        'htmlContent': '<p>Su código de validación es: <strong>$codigo</strong></p>'
      }),
    );

    if (response.statusCode == 201) {
      emit(FirmaCodigoEnviado());
    } else {
      emit(FirmaError('No se pudo enviar el código.'));
    }
  }

  void _iniciarTemporizador() {
    _temporizador = Timer(Duration(minutes: 1), () {
      _codigoGenerado = '';
      add(InvalidarCodigo());
    });
  }

  void _detenerTemporizador() {
    _temporizador?.cancel();
  }
}
