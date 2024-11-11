import 'package:corvi_app/src/data/api/ApiConfig.dart';
import 'package:corvi_app/src/domain/models/Repuestos.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShippingService {
  // Método para calcular el costo de envío
  Future<double> calculateShippingCost(List<Repuesto> products) async {
    try {
      // Usamos la URL base desde ApiConfig y completamos con el endpoint de cálculo
      Uri url = Uri.http(ApiConfig.API, '/shipping/calculate');

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "items": products.map((p) => {
            "id": p.idRepuestos, 
            "quantity": 1, // O actualiza con la cantidad específica si está disponible
            // Añadir otros detalles si son requeridos (e.g., peso, dimensiones)
          }).toList(),
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['shipping_cost'] ?? 0.0;
      } else {
        throw Exception("Error al calcular el envío: ${response.statusCode}");
      }
    } catch (e) {
      print("Error en calculateShippingCost: $e");
      return 0.0; // Devolver un costo de envío predeterminado en caso de error
    }
  }

  // Método para rastrear el envío usando el número de rastreo
  Future<String> trackShipping(String trackingNumber) async {
    try {
      Uri url = Uri.http(ApiConfig.API, '/shipping/track/$trackingNumber');
      final response = await http.get(url, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] ?? "Desconocido"; // Devuelve "Desconocido" si no hay estado
      } else {
        throw Exception("Error al rastrear el envío: ${response.statusCode}");
      }
    } catch (e) {
      print("Error en trackShipping: $e");
      return "Error al rastrear el envío";
    }
  }
}
