import 'package:bloc/bloc.dart';
import 'package:corvi_app/src/data/dataSource/remote/services/TrackingService.dart';
import 'TrackingEvent.dart';
import 'TrackingState.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final TrackingService trackingService;

  TrackingBloc(this.trackingService) : super(TrackingInitial()) {
    on<CreateTrackingEvent>(_onCreateTracking);
    on<GetTrackingEvent>(_onGetTracking);
    on<UpdateTrackingEvent>(_onUpdateTracking);
  }

  Future<void> _onCreateTracking(CreateTrackingEvent event, Emitter<TrackingState> emit) async {
    emit(TrackingLoading());
    try {
      final result = await trackingService.createTracking(event.codigoRastreo, event.destino);
      emit(TrackingSuccess(result));
    } catch (error) {
      emit(TrackingFailure(error.toString()));
    }
  }

  Future<void> _onGetTracking(GetTrackingEvent event, Emitter<TrackingState> emit) async {
    emit(TrackingLoading());
    try {
      final result = await trackingService.getTracking(event.codigoRastreo);
      emit(TrackingSuccess(result));
    } catch (error) {
      emit(TrackingFailure(error.toString()));
    }
  }

  Future<void> _onUpdateTracking(UpdateTrackingEvent event, Emitter<TrackingState> emit) async {
    emit(TrackingLoading());
    try {
      final result = await trackingService.updateTracking(event.codigoRastreo, event.estado, event.observaciones);
      emit(TrackingSuccess(result));
    } catch (error) {
      emit(TrackingFailure(error.toString()));
    }
  }
}
