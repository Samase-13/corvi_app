import 'package:corvi_app/src/data/dataSource/remote/services/TrackingService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/TrackingBloc.dart';
import 'bloc/TrackingEvent.dart';
import 'bloc/TrackingState.dart';

class TrackingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrackingBloc(TrackingService()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Rastreo de Envíos'),
        ),
        body: TrackingView(),
      ),
    );
  }
}

class TrackingView extends StatelessWidget {
  final TextEditingController codigoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TrackingBloc, TrackingState>(
      listener: (context, state) {
        if (state is TrackingFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        }
      },
      builder: (context, state) {
        if (state is TrackingLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is TrackingSuccess) {
          return Column(
            children: [
              Text('Código: ${state.trackingData['codigo_rastreo']}'),
              Text('Estado: ${state.trackingData['estado_actual']}'),
            ],
          );
        }

        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: codigoController,
                decoration: InputDecoration(labelText: 'Código de Rastreo'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<TrackingBloc>().add(GetTrackingEvent(codigoController.text));
                },
                child: Text('Buscar'),
              ),
            ],
          ),
        );
      },
    );
  }
}
