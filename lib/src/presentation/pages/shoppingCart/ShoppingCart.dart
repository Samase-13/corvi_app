import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:http/http.dart' as http;
import 'package:corvi_app/src/data/api/ApiConfig.dart';
import 'package:corvi_app/src/domain/models/Repuestos.dart';
import 'package:corvi_app/src/presentation/pages/shoppingCart/bloc/CartBloc.dart';
import 'package:corvi_app/src/presentation/pages/shoppingCart/bloc/CartState.dart';
import 'package:corvi_app/src/presentation/pages/shoppingCart/bloc/CartEvent.dart';

class ShoppingCart extends StatelessWidget {
  const ShoppingCart({super.key});

  Future<void> _startPayment(BuildContext context, List<Repuesto> productos, double total) async {
    try {
      // Construir el cuerpo para la solicitud al backend
      List<Map<String, dynamic>> productosPayload = productos
          .map((producto) => {
                "title": producto.nombre,
                "quantity": 1, // Puedes personalizar esta cantidad si tienes un contador
                "unit_price": producto.precio,
              })
          .toList();

      // Realizar la solicitud al backend para obtener el enlace de pago
      final response = await http.post(
        Uri.http(ApiConfig.API, "/mercado_pago/pago"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": ApiConfig.AUTH_TOKEN,
        },
        body: jsonEncode({
          "id_usuario": 1, // Asume que el usuario ya está autenticado y tiene un ID 1
          "productos": productosPayload,
          "destino": "Calle Principal 123, Lima, Perú", // Dirección de envío
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final paymentUrl = data['payment_url'];

        // Abre la URL del pago en el navegador
        await launchUrl(paymentUrl, context);
      } else {
        throw Exception("Error al generar el enlace de pago: ${response.body}");
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al procesar el pago: $error")),
      );
    }
  }

  Future<void> launchUrl(String url, BuildContext context) async {
    try {
      await launch(
        url,
        customTabsOption: CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al abrir la URL: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Carrito de Compras',
          style: TextStyle(
            fontFamily: 'Oswald',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartLoaded && state.productos.isNotEmpty) {
                    return ListView.builder(
                      itemCount: state.productos.length,
                      itemBuilder: (context, index) {
                        final Repuesto producto = state.productos[index];
                        return _buildCartItem(producto);
                      },
                    );
                  } else {
                    return const Center(child: Text('El carrito está vacío'));
                  }
                },
              ),
            ),
            Divider(thickness: 1, color: Colors.grey[300]),
            _buildSummarySection(context),
            const SizedBox(height: 20),
            _buildPayButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(Repuesto producto) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: const Color.fromARGB(255, 233, 233, 233),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.network(
              producto.imagen,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombre,
                    style: const TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'S/. ${producto.precio.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.amber[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        double subtotal = 0;

        if (state is CartLoaded) {
          subtotal = state.productos.fold(
              0, (sum, producto) => sum + producto.precio); // Suma de precios
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              _buildSummaryRow('Total:', 'S/. ${subtotal.toStringAsFixed(2)}',
                  isTotal: true),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Oswald',
              fontSize: 18,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Oswald',
              fontSize: 18,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton(BuildContext context) {
  return BlocBuilder<CartBloc, CartState>(
    builder: (context, state) {
      if (state is CartLoaded && state.productos.isNotEmpty) {
        double total = state.productos.fold(
            0, (sum, producto) => sum + producto.precio); // Suma total

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _startPayment(context, state.productos, total),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Pagar',
                style: TextStyle(
                  fontFamily: 'Oswald',
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'orders'); // Navegar a la página de pedidos
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Mis Pedidos',
                style: TextStyle(
                  fontFamily: 'Oswald',
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      } else {
        return const SizedBox.shrink();
      }
    },
  );
}

}
