import 'package:corvi_app/src/presentation/pages/envio/ShippingFormPage.dart';
import 'package:corvi_app/src/presentation/pages/rastreo/TrackShippingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:corvi_app/src/domain/models/Repuestos.dart';
import 'package:corvi_app/src/presentation/pages/shoppingCart/bloc/CartBloc.dart';
import 'package:corvi_app/src/presentation/pages/shoppingCart/bloc/CartState.dart';
import 'package:corvi_app/src/presentation/pages/shoppingCart/bloc/CartEvent.dart';
import 'package:provider/provider.dart';
import 'package:corvi_app/src/data/api/ApiConfig.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Agrega el OrderProvider en tu proyecto
class ShoppingCart extends StatelessWidget {
  const ShoppingCart({super.key});

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
                        final int cantidad =
                            state.cantidades[producto.idRepuestos] ?? 1;
                        return _buildCartItem(producto, cantidad, context);
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShippingFormPage()),
                    );
                  },
                  child: const Text('Calcular Envío'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TrackShippingPage()),
                    );
                  },
                  child: const Text('Rastrear Envío'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildSendButton(context), // Botón para enviar el pedido
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(Repuesto producto, int cantidad, BuildContext context) {
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
                    '${producto.voltaje} V',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF7A7A7A),
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
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    context
                        .read<CartBloc>()
                        .add(UpdateProductQuantity(producto, cantidad - 1));
                  },
                ),
                Text(
                  '$cantidad',
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    context
                        .read<CartBloc>()
                        .add(UpdateProductQuantity(producto, cantidad + 1));
                  },
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                context.read<CartBloc>().add(RemoveProductFromCart(producto));
              },
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
        const double envio = 18.00; // Costo de envío fijo
        bool hasProducts = false;

        if (state is CartLoaded) {
          subtotal = state.productos.fold(0, (sum, producto) {
            final cantidad = state.cantidades[producto.idRepuestos] ?? 1;
            return sum + (producto.precio * cantidad);
          });
          hasProducts = state.productos.isNotEmpty;
        }

        final total = hasProducts ? subtotal + envio : subtotal;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              _buildSummaryRow(
                  'Subtotal:', 'S/. ${subtotal.toStringAsFixed(2)}'),
              if (hasProducts) // Mostrar el envío solo si hay productos
                _buildSummaryRow('Envío:', 'S/. ${envio.toStringAsFixed(2)}'),
              _buildSummaryRow(
                'Total:',
                'S/. ${total.toStringAsFixed(2)}',
                isTotal: true,
              ),
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

  // Botón de Enviar Pedido
  Widget _buildSendButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Dirección de ejemplo, puedes obtenerla de un formulario de dirección
        String address = "123 Calle Principal, Ciudad, País";
        List<Map<String, dynamic>> products = [
          {"id": 1, "quantity": 2},
          {"id": 2, "quantity": 1},
        ]; // Reemplaza con los datos del carrito

        final url = Uri.http(ApiConfig.API, '/shipping/send');
        final response = await http.post(
          url,
          headers: {
            'Authorization': ApiConfig.AUTH_TOKEN,
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "address": address,
            "products": products,
          }),
        );

        if (response.statusCode == 201) {
          final data = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Pedido enviado correctamente. ID: ${data['order_id']}'),
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al enviar el pedido. Inténtalo de nuevo.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: const Text(
        'Enviar Pedido',
        style: TextStyle(
          fontFamily: 'Oswald',
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
