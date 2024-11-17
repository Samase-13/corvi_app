import 'dart:convert';
import 'package:corvi_app/src/data/api/ApiConfig.dart';
import 'package:http/http.dart' as http;

class TrackingService {
  Future<Map<String, dynamic>> createTracking(String codigoRastreo, String destino) async {
    final url = Uri.http(ApiConfig.API, '/tracking/create');
    final response = await http.post(
      url,
      headers: {
        'Authorization': ApiConfig.AUTH_TOKEN,
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'codigo_rastreo': codigoRastreo,
        'destino': destino,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al crear el código de rastreo');
    }
  }

  Future<Map<String, dynamic>> getTracking(String codigoRastreo) async {
    final url = Uri.http(ApiConfig.API, '/tracking/$codigoRastreo');
    final response = await http.get(
      url,
      headers: {
        'Authorization': ApiConfig.AUTH_TOKEN,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener el estado del rastreo');
    }
  }

  Future<Map<String, dynamic>> updateTracking(String codigoRastreo, String estado, String observaciones) async {
    final url = Uri.http(ApiConfig.API, '/tracking/update');
    final response = await http.post(
      url,
      headers: {
        'Authorization': ApiConfig.AUTH_TOKEN,
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'codigo_rastreo': codigoRastreo,
        'estado': estado,
        'observaciones': observaciones,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al actualizar el rastreo');
    }
  }
}
