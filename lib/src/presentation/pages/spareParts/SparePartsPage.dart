import 'package:corvi_app/src/domain/models/Maquinarias.dart';
import 'package:corvi_app/src/domain/models/Repuestos.dart';
import 'package:corvi_app/src/presentation/pages/machineryRental/bloc/MaquinariaBloc.dart';
import 'package:corvi_app/src/presentation/pages/machineryRental/bloc/MaquinariaState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:corvi_app/src/presentation/pages/spareParts/bloc/RepuestosBloc.dart';
import 'package:corvi_app/src/presentation/pages/spareParts/bloc/RepuestosState.dart';
import 'package:corvi_app/src/presentation/widgets/FilterChipWidget.dart';
import 'package:corvi_app/src/presentation/widgets/ProductCard.dart';
import 'package:corvi_app/src/presentation/widgets/SectionTitle.dart';

class SparePartsPage extends StatelessWidget {
  const SparePartsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              // Sección de Repuestos
              SectionTitle(
                title: 'Repuestos',
                showSeeAll: true,
                onSeeAllTap: () {
                  Navigator.pushNamed(context, 'parts');
                },
              ),
              const SizedBox(height: 10),
              BlocBuilder<RepuestosBloc, RepuestosState>(
                builder: (context, state) {
                  if (state is RepuestosLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is RepuestosLoaded) {
                    return _buildHorizontalListView(state.repuestos);
                  } else if (state is RepuestosError) {
                    return Center(child: Text('Error al cargar repuestos'));
                  }
                  return Container(); // Estado inicial
                },
              ),
              const SizedBox(height: 20),
              // Sección de Maquinaria
              SectionTitle(
                title: 'Reservar Maquinaria',
                showSeeAll: true,
                onSeeAllTap: () {
                  Navigator.pushNamed(context, 'maquinaria');
                },
              ),
              const SizedBox(height: 10),
              BlocBuilder<MaquinariaBloc, MaquinariaState>(
                builder: (context, state) {
                  if (state is MaquinariaLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MaquinariaLoaded) {
                    return _buildHorizontalListView(state.maquinaria);
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
                  offset: const Offset(0, 4),
                ),
              ],
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon:
                    const Icon(Icons.search, color: Colors.black, size: 30),
                hintText: 'Buscar',
                hintStyle: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Oswald',
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(
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
          child: const Icon(Icons.tune, color: Colors.black, size: 30),
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
          FilterChipWidget(label: 'All', isSelected: true),
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

  // Widget para construir la lista horizontal para repuestos o maquinaria
  Widget _buildHorizontalListView(List<dynamic> items) {
    final limitedItems =
        items.take(5).toList(); // Limitar a los primeros 5 elementos

    return SizedBox(
      height: 400,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: limitedItems.length,
        itemBuilder: (context, index) {
          final item = limitedItems[index];
          String imagePath;
          String productName;
          int itemId;
          String routeName; // Nueva variable para la ruta

          // Diferenciar entre Repuesto y Maquinaria
          if (item is Repuesto) {
            imagePath = item.imagen; // Usar `imagen` para Repuesto
            productName = item.nombre;
            itemId = item.idRepuestos;
            routeName = 'descriptionParts'; // Ruta para detalles de repuestos
          } else if (item is Maquinaria) {
            imagePath = item.img; // Usar `img` para Maquinaria
            productName = item.nombre;
            itemId = item.idMaquinaria;
            routeName = 'descriptionMachinery'; // Ruta para detalles de maquinaria
          } else {
            return Container(); // En caso de que el item no sea ninguno de los dos, devolver un contenedor vacío
          }

          return ProductCard(
            imagePath: imagePath,
            productName: productName,
            onTap: () {
              Navigator.pushNamed(
                context,
                routeName, // Usa la ruta según el tipo
                arguments: itemId, // Pasar el ID correspondiente
              );
            },
          );
        },
      ),
    );
  }
}
