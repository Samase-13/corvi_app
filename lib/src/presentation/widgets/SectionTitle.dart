import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final bool showSeeAll;
  final VoidCallback? onSeeAllTap;

  const SectionTitle({
    super.key,
    required this.title,
    this.showSeeAll = true,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible( // Cambiado a Flexible
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              overflow: TextOverflow.ellipsis, // Opcional: añade esto para que el texto se recorte si es muy largo
            ),
          ),
        ),
        if (showSeeAll)
          GestureDetector(
            onTap: onSeeAllTap,
            child: Text(
              'Ver todos',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
      ],
    );
  }
}
