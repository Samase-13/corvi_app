import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:corvi_app/src/data/api/ApiConfig.dart';

class OrdersScreen extends StatelessWidget {
  final int userId; // ID del usuario que se pasó al iniciar sesión

  OrdersScreen({required this.userId});

  Future<List<dynamic>> _fetchOrders() async {
    final url = Uri.http(ApiConfig.API, "/pedidos/usuario/$userId");
    final response = await http.get(
      url,
      headers: {
        'Authorization': ApiConfig.AUTH_TOKEN,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al obtener los pedidos: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Pedidos"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No tienes pedidos aún."));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final productos = order["productos"] as List<dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Código de rastreo: ${order["codigo_rastreo"]}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text("Fecha: ${order["fecha_creacion"]}"),
                      const SizedBox(height: 10),
                      const Text(
                        "Productos:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...productos.map((producto) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Image.network(
                                producto["imagen"] ?? "", // URL de la imagen
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(
                                  Icons.broken_image,
                                  size: 50,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "${producto["title"]} x${producto["quantity"]}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total: S/. ${order["total"]}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                'tracking',
                                arguments: order["codigo_rastreo"],
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              "Rastrear",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
