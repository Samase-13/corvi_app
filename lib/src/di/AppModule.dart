import 'package:corvi_app/src/data/dataSource/remote/services/MaquinariaService.dart';
import 'package:corvi_app/src/data/dataSource/remote/services/RepuestosService.dart';
import 'package:corvi_app/src/data/dataSource/remote/services/RucServiced.dart';
import 'package:corvi_app/src/data/dataSource/remote/services/DisponibilidadService.dart'; // Importa el servicio de Disponibilidad
import 'package:corvi_app/src/data/repository/DisponiblidadRepositoryImpl.dart';
import 'package:corvi_app/src/data/repository/MaquinariaRepositoryImpl.dart';
import 'package:corvi_app/src/data/repository/RepuestosRepositoryImpl.dart';
import 'package:corvi_app/src/data/repository/RucRepositoryImpl.dart';
import 'package:corvi_app/src/domain/repository/MaquinariaRepository.dart';
import 'package:corvi_app/src/domain/repository/RepuestosRepository.dart';
import 'package:corvi_app/src/domain/repository/RucRepository.dart';
import 'package:corvi_app/src/domain/repository/DisponibilidadRepository.dart'; // Importa la interfaz del repositorio de Disponibilidad
import 'package:corvi_app/src/domain/useCases/disponibilidad/GuardarDisponibilidadUseCase.dart';
import 'package:corvi_app/src/domain/useCases/maquinaria/MaquinariaUseCase.dart';
import 'package:corvi_app/src/domain/useCases/maquinaria/MaquinariaUseCases.dart';
import 'package:corvi_app/src/domain/useCases/repuestos/RepuestosUseCase.dart';
import 'package:corvi_app/src/domain/useCases/repuestos/RepuestosUseCases.dart';
import 'package:corvi_app/src/domain/useCases/Ruc/FecthRucUseCase.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AppModule {
  // Inyección para Repuestos
  @injectable
  RepuestosService get repuestosServices => RepuestosService();

  @injectable
  RepuestosRepository get authRepository => RepuestosRepositoryImpl(repuestosServices);

  @injectable
  RepuestosUseCases get repuestosUseCases => RepuestosUseCases(
    repuestos: RepuestosUseCase(authRepository)
  );

  // Inyección para Maquinaria
  @injectable
  MaquinariaService get maquinariaServices => MaquinariaService();

  @injectable
  MaquinariaRepository get maquinariaRepository => MaquinariaRepositoryImpl(maquinariaServices);

  @injectable
  MaquinariaUseCases get maquinariaUseCases => MaquinariaUseCases(
    maquinaria: MaquinariaUseCase(maquinariaRepository)
  );

  // Inyección para RUC
  @injectable
  RucService get rucService => RucService();

  @injectable
  RucRepository get rucRepository => RucRepositoryImpl(rucService);

  @injectable
  FetchRucUseCase get fetchRucUseCase => FetchRucUseCase(rucRepository);

  // Inyección para Disponibilidad
  @injectable
  DisponibilidadService get disponibilidadService => DisponibilidadService();

  @injectable
  DisponibilidadRepository get disponibilidadRepository => DisponibilidadRepositoryImpl(disponibilidadService);

  @injectable
  GuardarDisponibilidadUseCase get guardarDisponibilidadUseCase => GuardarDisponibilidadUseCase(disponibilidadRepository);
}
