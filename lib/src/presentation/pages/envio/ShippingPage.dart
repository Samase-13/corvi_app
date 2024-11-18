import 'package:flutter/material.dart';


class ShippingPage extends StatelessWidget {
  final Function(String destino, String codigoRastreo) onAddressSaved;

  const ShippingPage({Key? key, required this.onAddressSaved}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _destinationController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lugar de Envío"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ingresa la dirección de envío:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _destinationController,
                decoration: const InputDecoration(
                  labelText: "Dirección de Envío",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingresa una dirección válida.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final destino = _destinationController.text;
                    final codigoRastreo = "CR${DateTime.now().millisecondsSinceEpoch}";

                    onAddressSaved(destino, codigoRastreo); // Llama al callback
                    Navigator.pop(context); // Vuelve al carrito
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                child: const Text("Guardar Dirección"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
