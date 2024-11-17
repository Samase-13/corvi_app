import 'package:corvi_app/src/data/api/ApiConfig.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Importa para manejar JSON

class PaymentService {
  Future<String> createPreference({
    required int idUsuario,
    required List<Map<String, dynamic>> productos,
    required String destino,
  }) async {
    final url = Uri.http(ApiConfig.API, "/mercado_pago/pago"); // Endpoint actualizado
    final headers = {
      "Content-Type": "application/json",
      "Authorization": ApiConfig.AUTH_TOKEN, // Token para autenticación
    };

    // Construir el cuerpo de la solicitud con los datos dinámicos
    final body = jsonEncode({
      "id_usuario": idUsuario,
      "productos": productos,
      "destino": destino,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['payment_url']; // Retorna el enlace de pago
      } else {
        throw Exception(
            "Error al crear la preferencia: ${response.body}"); // Manejo de errores
      }
    } catch (error) {
      throw Exception("Error al conectarse al backend: $error");
    }
  }
}
