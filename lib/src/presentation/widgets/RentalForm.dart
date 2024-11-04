import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:corvi_app/src/presentation/pages/signature/FirmaBloc.dart';
import 'package:corvi_app/src/presentation/pages/signature/FirmaEvent.dart';
import 'package:corvi_app/src/presentation/pages/signature/FirmaState.dart';
import 'package:corvi_app/src/presentation/pages/ruc/bloc/RucBloc.dart';
import 'package:corvi_app/src/presentation/pages/ruc/bloc/RucEvent.dart';
import 'package:corvi_app/src/presentation/pages/ruc/bloc/RucState.dart';
import 'package:corvi_app/src/presentation/pages/calendar/bloc/DisponibilidadBloc.dart';
import 'package:corvi_app/src/presentation/pages/calendar/bloc/DisponibilidadEvent.dart';
import 'package:corvi_app/src/presentation/pages/calendar/bloc/DisponibilidadState.dart';
import 'package:corvi_app/src/domain/models/Disponibilidad.dart';

class RentalForm extends StatefulWidget {
  final String precioTipo;
  final double precio;

  const RentalForm({super.key, required this.precioTipo, required this.precio});

  @override
  _RentalFormState createState() => _RentalFormState();
}

class _RentalFormState extends State<RentalForm> {
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _rucController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();
  double _total = 0.0;

  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? fechaInicio = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (fechaInicio != null) {
      final DateTime? fechaFin = await showDatePicker(
        context: context,
        initialDate: fechaInicio.add(Duration(days: 1)),
        firstDate: fechaInicio,
        lastDate: DateTime(2030),
      );

      if (fechaFin != null) {
        setState(() {
          _fechaInicio = fechaInicio;
          _fechaFin = fechaFin;
          _dateController.text =
              '${fechaInicio.day}/${fechaInicio.month}/${fechaInicio.year} - ${fechaFin.day}/${fechaFin.month}/${fechaFin.year}';
          _calcularTotal();
        });

        final disponibilidad = Disponibilidad(
          idMaquinaria: 1, // Cambia a la ID de maquinaria correcta
          fechaInicio: fechaInicio,
          fechaFin: fechaFin,
        );

        context
            .read<DisponibilidadBloc>()
            .add(GuardarDisponibilidadEvent(disponibilidad));
      }
    }
  }

  void _calcularTotal() {
    if (widget.precioTipo == 'por día' && _fechaInicio != null && _fechaFin != null) {
      final dias = _fechaFin!.difference(_fechaInicio!).inDays + 1;
      _total = widget.precio * dias;
    } else if (widget.precioTipo == 'por hora' && _hoursController.text.isNotEmpty) {
      final horas = int.tryParse(_hoursController.text) ?? 0;
      _total = widget.precio * horas;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          _buildTextField('Horas', _hoursController, enabled: widget.precioTipo != 'por día', onChanged: _calcularTotal),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField('RUC', _rucController),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final ruc = _rucController.text;
                  if (ruc.isNotEmpty) {
                    BlocProvider.of<RucBloc>(context).add(FetchRucEvent(ruc));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBCBCBC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
                child: const Text(
                  'Validar',
                  style: TextStyle(
                    fontFamily: 'Oswald',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: AbsorbPointer(
              child:
                  _buildTextField('Elegir fecha de alquiler', _dateController),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Total a Pagar: S/. ${_total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontFamily: 'Oswald',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 24),
          BlocConsumer<RucBloc, RucState>(
            listener: (context, state) {
              if (state is RucError) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red),
                          SizedBox(width: 8),
                          Text("Error"),
                        ],
                      ),
                      content: Text('RUC Inválido: ${state.message}'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("Cerrar"),
                        ),
                      ],
                    );
                  },
                );
              } else if (state is RucSuccess) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text("Validación Exitosa"),
                        ],
                      ),
                      content: Text('El RUC ha sido validado correctamente.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("Cerrar"),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            builder: (context, state) {
              if (state is RucLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is RucSuccess) {
                return _buildRucDetails(state);
              } else {
                return Container();
              }
            },
          ),
          BlocConsumer<DisponibilidadBloc, DisponibilidadState>(
            listener: (context, state) {
              if (state is DisponibilidadSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fechas Guardadas con Exito')),
                );
              } else if (state is DisponibilidadError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              if (state is DisponibilidadLoading) {
                return Center(child: CircularProgressIndicator());
              }
              return Container();
            },
          ),
          BlocConsumer<FirmaBloc, FirmaState>(
            listener: (context, state) {
              if (state is FirmaCodigoEnviado) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Código de validación enviado a su correo.'),
                ));
              } else if (state is FirmaCodigoValidado) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Contrato firmado exitosamente.'),
                ));
              } else if (state is FirmaError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Error: ${state.message}'),
                ));
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  if (state is FirmaEsperandoCodigo || state is FirmaCodigoEnviado)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        controller: _codigoController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Ingrese el código de validación',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  if (state is FirmaEsperandoCodigo || state is FirmaCodigoEnviado)
                    ElevatedButton(
                      onPressed: () {
                        final codigoIngresado = _codigoController.text;
                        context.read<FirmaBloc>().add(ValidarCodigo(codigoIngresado));
                      },
                      child: Text('Validar código'),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      if (state is! FirmaEsperandoCodigo &&
                          state is! FirmaCodigoEnviado) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('¿Estás seguro de firmar el contrato?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<FirmaBloc>().add(EnviarCodigo());
                                  Navigator.pop(context);
                                },
                                child: Text('Firmar'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Text('Firmar contrato'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool enabled = true, void Function()? onChanged}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'Oswald',
          fontSize: 16,
          color: Colors.black,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      keyboardType: label == 'Horas' || label == 'RUC'
          ? TextInputType.number
          : TextInputType.text,
      style: const TextStyle(
        fontSize: 14,
        fontFamily: 'Oswald',
      ),
      onChanged: (_) => onChanged?.call(),
    );
  }

  Widget _buildRucDetails(RucSuccess state) {
    final data = state.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Número de Documento:', data.numeroDocumento),
        _buildDetailRow('Razón Social:', data.razonSocial),
        _buildDetailRow('Estado:', data.estado),
        _buildDetailRow('Condición:', data.condicion),
      ],
    );
  }

  Widget _buildDetailRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$title ',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'No disponible',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
