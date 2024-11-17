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

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTrackingDetailsCard(trackingData),
                  const SizedBox(height: 20),
                  const Text(
                    "Historial",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildTimeline(historial),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrackingDetailsCard(Map<String, dynamic> trackingData) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow("Código de rastreo:", trackingData["codigo_rastreo"]),
            _buildDetailRow("Estado actual:", trackingData["estado_actual"]),
            _buildDetailRow("Destino:", trackingData["destino"]),
            _buildDetailRow("Fecha de envío:", trackingData["fecha_envio"]),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(List<dynamic> historial) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: historial.length,
      itemBuilder: (context, index) {
        final entry = historial[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              _buildTimelineIndicator(index, historial.length),
              const SizedBox(width: 10),
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry["estado"],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        Text(entry["fecha"]),
                        if (entry["observaciones"] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              entry["observaciones"],
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimelineIndicator(int index, int length) {
    return Column(
      children: [
        if (index > 0)
          Container(
            width: 2,
            height: 20,
            color: Colors.grey,
          ),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
        ),
        if (index < length - 1)
          Container(
            width: 2,
            height: 20,
            color: Colors.grey,
          ),
      ],
    );
  }
}
