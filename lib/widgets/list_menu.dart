import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resto_app/common/style.dart';
import 'package:resto_app/data/model/restaurant_detail_item.dart';

class ListMenu extends StatelessWidget {
  final List<Category> menu;
  final Color backgroundColor;
  const ListMenu(
      {super.key, required this.menu, required this.backgroundColor});

  Widget _buildMenuItem(BuildContext context, String name, Color background) {
    return Card(
      elevation: 0,
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
            color: Colors.grey, width: 0.5), // Adjust the border radius here
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
          child: Row(
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: myTextTheme.labelLarge?.copyWith(
                    color: const Color.fromARGB(255, 67, 120, 146),
                    fontFamily: GoogleFonts.rubik().fontFamily,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                    letterSpacing: 0.2,
                    fontSize: 12),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: menu
            .map((item) => _buildMenuItem(context, item.name, backgroundColor))
            .toList(),
      ),
    );
  }
}
