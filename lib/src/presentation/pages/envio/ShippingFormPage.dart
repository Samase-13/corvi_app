import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:corvi_app/src/presentation/pages/shoppingCart/bloc/CartBloc.dart';
import 'package:corvi_app/src/presentation/pages/shoppingCart/bloc/CartEvent.dart';
import 'package:corvi_app/src/presentation/pages/shoppingCart/bloc/CartState.dart';

class ShippingFormPage extends StatefulWidget {
  @override
  _ShippingFormPageState createState() => _ShippingFormPageState();
}

class _ShippingFormPageState extends State<ShippingFormPage> {
  final _formKey = GlobalKey<FormState>();
  String address = '';
  String city = '';
  String postalCode = '';
  bool _isLoading = false; // Variable para el estado de carga

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        setState(() {
          _isLoading = false; // Detener la carga cuando hay una respuesta
        });
        if (state is ShippingCalculated) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Costo de Envío"),
              content: Text("El costo de envío es S/. ${state.shippingCost.toStringAsFixed(2)}"),
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
        appBar: AppBar(title: Text('Información de Envío')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Dirección'),
                  validator: (value) => value!.isEmpty ? 'Ingrese su dirección' : null,
                  onSaved: (value) => address = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Ciudad'),
                  validator: (value) => value!.isEmpty ? 'Ingrese su ciudad' : null,
                  onSaved: (value) => city = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Código Postal'),
                  validator: (value) => value!.isEmpty ? 'Ingrese su código postal' : null,
                  onSaved: (value) => postalCode = value!,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() {
                        _isLoading = true; // Mostrar el indicador de carga
                      });
                      context.read<CartBloc>().add(
                        CalculateShipping(address, city, postalCode),
                      );
                    }
                  },
                  child: _isLoading 
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Calcular Envío'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
