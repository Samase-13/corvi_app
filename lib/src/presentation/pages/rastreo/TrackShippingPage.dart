import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:corvi_app/src/presentation/pages/shoppingCart/bloc/CartBloc.dart';
import 'package:corvi_app/src/presentation/pages/shoppingCart/bloc/CartEvent.dart';
import 'package:corvi_app/src/presentation/pages/shoppingCart/bloc/CartState.dart';

class TrackShippingPage extends StatefulWidget {
  @override
  _TrackShippingPageState createState() => _TrackShippingPageState();
}

class _TrackShippingPageState extends State<TrackShippingPage> {
  final _trackingController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        setState(() {
          _isLoading = false; // Desactivar el indicador de carga al recibir respuesta
        });
        if (state is ShippingTracked) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Estado del Envío"),
              content: Text("Estado actual: ${state.status}"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Aceptar"),
                ),
              ],
            ),
          );
        } else if (state is CartError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.mensaje)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Rastrear Envío')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _trackingController,
                decoration: InputDecoration(
                  labelText: 'Número de Rastreo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : () {
                  final trackingNumber = _trackingController.text;
                  if (trackingNumber.isNotEmpty) {
                    setState(() {
                      _isLoading = true; // Iniciar estado de carga
                    });
                    context.read<CartBloc>().add(TrackShipping(trackingNumber));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Por favor, ingrese un número de rastreo')),
                    );
                  }
                },
                child: _isLoading 
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Rastrear Envío'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is ShippingTracked) {
                    return Text('Estado de Envío: ${state.status}');
                  } else if (state is CartError) {
                    return Text('Error: ${state.mensaje}');
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
