import 'package:corvi_app/src/domain/models/Repuestos.dart';
import 'package:corvi_app/src/presentation/pages/spareParts/bloc/RepuestosBloc.dart';
import 'package:corvi_app/src/presentation/pages/spareParts/bloc/RepuestosState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:corvi_app/src/presentation/widgets/FilterChipWidget.dart';
import 'package:corvi_app/src/presentation/widgets/ProductCard.dart';
import 'package:corvi_app/src/presentation/widgets/SectionTitle.dart';

class PartsPage extends StatelessWidget {
  const PartsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Bloque que escucha el estado de RepuestosBloc
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildSearchAndFilterRow(),
              const SizedBox(height: 20),
              _buildFilterChips(),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
              BlocBuilder<RepuestosBloc, RepuestosState>(
                builder: (context, state) {
                  if (state is RepuestosLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is RepuestosLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionTitle(
                            title: 'Electrobombas',
                            showSeeAll: false), // No mostramos "Ver todos"
                        const SizedBox(height: 10),
                        _buildHorizontalListView(filtrarRepuestosPorCategoria(
                            state.repuestos, 'Electrobombas')),

                        const SizedBox(height: 20),
                        SectionTitle(
                            title: 'Compresores y Filtros',
                            showSeeAll: false), // No mostramos "Ver todos"
                        const SizedBox(height: 10),
                        _buildHorizontalListView(filtrarRepuestosPorCategoria(
                            state.repuestos, 'Compresores y Filtros')),

                        const SizedBox(height: 20),
                        SectionTitle(
                            title: 'Contactores de Alta Capacidad',
                            showSeeAll: false), // No mostramos "Ver todos"
                        const SizedBox(height: 10),
                        _buildHorizontalListView(filtrarRepuestosPorCategoria(
                            state.repuestos, 'Contactores de Alta Capacidad')),

                        const SizedBox(height: 20),
                        SectionTitle(
                            title: 'Contactores de Baja Capacidad',
                            showSeeAll: false), // No mostramos "Ver todos"
                        const SizedBox(height: 10),
                        _buildHorizontalListView(filtrarRepuestosPorCategoria(
                            state.repuestos, 'Contactores de Baja Capacidad')),

                        const SizedBox(height: 20),
                        SectionTitle(
                            title: 'Capacitores de Trabajo (Alta Capacidad)',
                            showSeeAll: false), // No mostramos "Ver todos"
                        const SizedBox(height: 10),
                        _buildHorizontalListView(filtrarRepuestosPorCategoria(
                            state.repuestos,
                            'Capacitores de Trabajo (Alta Capacidad)')),

                        const SizedBox(height: 20),
                        SectionTitle(
                            title: 'Capacitores de Trabajo (Baja Capacidad)',
                            showSeeAll: false), // No mostramos "Ver todos"
                        const SizedBox(height: 10),
                        _buildHorizontalListView(filtrarRepuestosPorCategoria(
                            state.repuestos,
                            'Capacitores de Trabajo (Baja Capacidad)')),

                        const SizedBox(height: 20),
                        SectionTitle(
                            title: 'Capacitores de Arranque (Alta Capacidad)',
                            showSeeAll: false), // No mostramos "Ver todos"
                        const SizedBox(height: 10),
                        _buildHorizontalListView(filtrarRepuestosPorCategoria(
                            state.repuestos,
                            'Capacitores de Arranque (Alta Capacidad)')),

                        const SizedBox(height: 20),
                        SectionTitle(
                            title: 'Capacitores de Arranque (Baja Capacidad)',
                            showSeeAll: false), // No mostramos "Ver todos"
                        const SizedBox(height: 10),
                        _buildHorizontalListView(filtrarRepuestosPorCategoria(
                            state.repuestos,
                            'Capacitores de Arranque (Baja Capacidad)')),
                      ],
                    );
                  } else if (state is RepuestosError) {
                    return Center(child: Text('Error al cargar repuestos'));
                  }
                  return Container(); // Estado inicial
                },
              ),

              const SizedBox(height: 20),
              _buildHorizontalListView([]), // Temporariamente vacío
            ],
          ),
        ),
      ),
    );
  }

  // Mueve la función filtrarRepuestosPorCategoria aquí
  List<Repuesto> filtrarRepuestosPorCategoria(
      List<Repuesto> repuestos, String categoria) {
    switch (categoria) {
      case 'Electrobombas':
        return repuestos
            .where((r) => r.nombre.contains('Electrobomba'))
            .toList();
      case 'Compresores y Filtros':
        return repuestos
            .where((r) =>
                r.nombre.contains('Compresor') || r.nombre.contains('Filtro'))
            .toList();
      case 'Contactores de Alta Capacidad':
        return repuestos
            .where((r) =>
                r.nombre.contains('Chint') &&
                (r.nombre.contains('115 A') ||
                    r.nombre.contains('80 A') ||
                    r.nombre.contains('65 A')))
            .toList();
      case 'Contactores de Baja Capacidad':
        return repuestos
            .where((r) =>
                r.nombre.contains('Chint') &&
                (r.nombre.contains('50 A') ||
                    r.nombre.contains('40 A') ||
                    r.nombre.contains('32 A') ||
                    r.nombre.contains('25 A') ||
                    r.nombre.contains('18 A') ||
                    r.nombre.contains('12 A')))
            .toList();
      case 'Capacitores de Trabajo (Alta Capacidad)':
        return repuestos
            .where((r) =>
                r.nombre.contains('Capacitor Trabajo') &&
                (r.nombre.contains('25') ||
                    r.nombre.contains('30') ||
                    r.nombre.contains('35') ||
                    r.nombre.contains('40') ||
                    r.nombre.contains('45') ||
                    r.nombre.contains('50')))
            .toList();
      case 'Capacitores de Trabajo (Baja Capacidad)':
        return repuestos
            .where((r) =>
                r.nombre.contains('Capacitor Trabajo') &&
                (r.nombre.contains('5') ||
                    r.nombre.contains('8') ||
                    r.nombre.contains('10') ||
                    r.nombre.contains('12') ||
                    r.nombre.contains('15') ||
                    r.nombre.contains('16') ||
                    r.nombre.contains('17') ||
                    r.nombre.contains('20')))
            .toList();
      case 'Capacitores de Arranque (Alta Capacidad)':
        return repuestos
            .where((r) =>
                r.nombre.contains('Capacitor Arranque') &&
                (r.nombre.contains('124-149') ||
                    r.nombre.contains('189-227') ||
                    r.nombre.contains('200-240') ||
                    r.nombre.contains('250')))
            .toList();
      case 'Capacitores de Arranque (Baja Capacidad)':
        return repuestos
            .where((r) =>
                r.nombre.contains('Capacitor Arranque') &&
                (r.nombre.contains('72-86') || r.nombre.contains('108-130')))
            .toList();
      default:
        return repuestos;
    }
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
          FilterChipWidget(label: 'Electrobombas'),
          FilterChipWidget(label: 'Compresores y Filtros'),
          FilterChipWidget(label: 'Contactores'),
          FilterChipWidget(label: 'Capacitores de Trabajo'),
          FilterChipWidget(label: 'Capacitores de Arranque'),
        ],
      ),
    );
  }

  // Widget para construir la lista horizontal
  Widget _buildHorizontalListView(List<dynamic> repuestos) {
    return SizedBox(
      height: 400, // Ajustamos el tamaño de las tarjetas
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: repuestos.length,
        itemBuilder: (context, index) {
          final repuesto = repuestos[index];
          return ProductCard(
            imagePath: repuesto.imagen,
            productName: repuesto.nombre,
            onTap: () {
              // Navegar a la página de descripción al hacer clic en la tarjeta
              Navigator.pushNamed(
                context,
                'descriptionParts',
                arguments:
                    repuesto.idRepuestos, // Asegúrate de pasar el id aquí
              );
            },
          );
        },
      ),
    );
  }
}
