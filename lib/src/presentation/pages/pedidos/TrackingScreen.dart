import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:corvi_app/src/data/api/ApiConfig.dart';

class TrackingScreen extends StatelessWidget {
  final String codigoRastreo;

  TrackingScreen({required this.codigoRastreo});

  Future<Map<String, dynamic>> _fetchTrackingDetails() async {
    final url = Uri.http(ApiConfig.API, "/tracking/$codigoRastreo");
    final response = await http.get(
      url,
      headers: {
        'Authorization': ApiConfig.AUTH_TOKEN,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al obtener el rastreo: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle de Rastrear Pedido"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchTrackingDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No se encontraron detalles."));
          }

          final trackingData = snapshot.data!;
          final historial = trackingData["historial"] as List<dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Código de rastreo: ${trackingData["codigo_rastreo"]}"),
                Text("Estado actual: ${trackingData["estado_actual"]}"),
                Text("Destino: ${trackingData["destino"]}"),
                Text("Fecha de envío: ${trackingData["fecha_envio"]}"),
                const SizedBox(height: 10),
                const Text("Historial:", style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: historial.length,
                    itemBuilder: (context, index) {
                      final entry = historial[index];
                      return ListTile(
                        leading: const Icon(Icons.timeline),
                        title: Text(entry["estado"]),
                        subtitle: Text("${entry["fecha"]}\n${entry["observaciones"] ?? ''}"),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
