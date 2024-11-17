import 'dart:convert'; // Para manejar JSON
import 'package:corvi_app/src/data/api/ApiConfig.dart';
import 'package:corvi_app/src/presentation/pages/pagos/PaymentPage_Services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart'; // Importar la librería correcta

class PaymentScreen extends StatefulWidget {
  final int idUsuario; // Recibe el ID del usuario
  final List<Map<String, dynamic>> productos; // Recibe los productos del carrito
  final String destino; // Recibe el destino del envío

  PaymentScreen({
    required this.idUsuario,
    required this.productos,
    required this.destino,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;

  Future<void> _startPayment() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Usa el servicio actualizado para obtener el enlace de pago
      final String paymentLink = await PaymentService().createPreference(
        idUsuario: widget.idUsuario,
        productos: widget.productos,
        destino: widget.destino,
      );

      // Abre el enlace en un navegador Custom Tab
      await launch(
        paymentLink,
        customTabsOption: CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $error'),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pago con Mercado Pago'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _startPayment,
                child: Text('Pagar'),
              ),
      ),
    );
  }
}
