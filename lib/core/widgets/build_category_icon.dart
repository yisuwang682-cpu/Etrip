import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildCategoryIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? route;
  final VoidCallback? onTap;

  const BuildCategoryIcon(
      {super.key,
      required this.icon,
      required this.label,
      this.route,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => GoRouter.of(context).push(route!),
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0xFF1F2544),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(label,
              style: GoogleFonts.playfairDisplay(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2544))),
        ],
      ),
    );
  }
}
