import 'package:corvi_app/src/domain/models/Maquinarias.dart';
import 'package:corvi_app/src/presentation/pages/machineryRental/bloc/MaquinariaBloc.dart';
import 'package:corvi_app/src/presentation/pages/machineryRental/bloc/MaquinariaState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:corvi_app/src/presentation/widgets/FilterChipWidget.dart';
import 'package:corvi_app/src/presentation/widgets/ProductCard.dart';
import 'package:corvi_app/src/presentation/widgets/SectionTitle.dart';

class MachineryRentalPage extends StatelessWidget {
  const MachineryRentalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final maquinariaBloc = BlocProvider.of<MaquinariaBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildSearchAndFilterRow(),
              const SizedBox(height: 20),
              _buildFilterChips(),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
              BlocBuilder<MaquinariaBloc, MaquinariaState>(
                builder: (context, state) {
                  if (state is MaquinariaLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MaquinariaLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMaquinariaSection(
                          context,
                          maquinariaBloc,
                          'Excavadoras',
                          state.maquinaria,
                        ),
                        _buildMaquinariaSection(
                          context,
                          maquinariaBloc,
                          'Cargadores',
                          state.maquinaria,
                        ),
                        _buildMaquinariaSection(
                          context,
                          maquinariaBloc,
                          'Bulldozers',
                          state.maquinaria,
                        ),
                        _buildMaquinariaSection(
                          context,
                          maquinariaBloc,
                          'Retroexcavadora',
                          state.maquinaria,
                        ),
                        _buildMaquinariaSection(
                          context,
                          maquinariaBloc,
                          'Rodillos Compactadores',
                          state.maquinaria,
                        ),
                        _buildMaquinariaSection(
                          context,
                          maquinariaBloc,
                          'Camiones de Volquete',
                          state.maquinaria,
                        ),
                        _buildMaquinariaSection(
                          context,
                          maquinariaBloc,
                          'Tractores',
                          state.maquinaria,
                        ),
                      ],
                    );
                  } else if (state is MaquinariaError) {
                    return Center(child: Text('Error al cargar maquinaria'));
                  }
                  return Container(); // Estado inicial
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para construir cada sección de maquinaria según el tipo
  Widget _buildMaquinariaSection(BuildContext context, MaquinariaBloc bloc,
      String tipo, List<Maquinaria> maquinaria) {
    final maquinariaFiltrada = bloc.filtrarMaquinariaPorTipo(maquinaria, tipo);

    if (maquinariaFiltrada.isEmpty) {
      return Container(); // Si no hay maquinaria del tipo, no se muestra
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: tipo,
          showSeeAll: false, // No mostramos "Ver todos"
        ),
        const SizedBox(height: 10),
        _buildHorizontalListView(maquinariaFiltrada),
        const SizedBox(height: 20),
      ],
    );
  }

  // Widget para construir el encabezado (logo y perfil)
  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CorviTrack',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontFamily: 'Oswald',
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
              ),
              Text(
                'Maquinaria a tu alcance, siempre.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: 'Montserrat',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF7A7A7A),
                    ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Icon(
            Icons.account_circle,
            color: Colors.grey,
            size: 70,
          ),
        ),
      ],
    );
  }

  // Widget para construir el TextField de búsqueda y el botón de filtro
  Widget _buildSearchAndFilterRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 15,
                  offset: Offset(0, 4),
                ),
              ],
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search, color: Colors.black, size: 30),
                hintText: 'Buscar',
                hintStyle: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Oswald',
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFC107),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(10),
          child: Icon(Icons.tune, color: Colors.black, size: 30),
        ),
      ],
    );
  }

  // Widget para construir los Filter Chips
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChipWidget(label: 'Todos', isSelected: true),
          FilterChipWidget(label: 'Excavadoras'),
          FilterChipWidget(label: 'Cargadores'),
          FilterChipWidget(label: 'Bulldozers'),
          FilterChipWidget(label: 'Retroexcavadora'),
          FilterChipWidget(label: 'Rodillos Compactadores'),
          FilterChipWidget(label: 'Camiones de Volquete'),
          FilterChipWidget(label: 'Tractores'),
        ],
      ),
    );
  }

  // Widget para construir la lista horizontal de maquinaria
  Widget _buildHorizontalListView(List<Maquinaria> maquinaria) {
    return SizedBox(
      height: 400, // Ajustamos el tamaño de las tarjetas
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: maquinaria.length,
        itemBuilder: (context, index) {
          final item = maquinaria[index];
          return ProductCard(
            imagePath: item.img,
            productName: item.nombre,
            onTap: () {
              // Navegar a la página de descripción al hacer clic en la tarjeta
              Navigator.pushNamed(
                context,
                'descriptionMachinery', // Ruta para descripción de maquinaria
                arguments: item.idMaquinaria, // Pasar el id
              );
            },
          );
        },
      ),
    );
  }
}
