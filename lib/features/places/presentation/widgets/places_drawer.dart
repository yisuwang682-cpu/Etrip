import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:egyptopia/core/widgets/custom_buttons.dart';

class PlacesDrawer extends StatelessWidget {
  final List<String> cities;
  final List<String> tourismTypes;
  final List<String> categories;
  final List<String> popularityOptions;
  final String? selectedCity;
  final String? selectedTourismType;
  final String? selectedCategory;
  final String? selectedPopularity;
  final void Function(String?)? onCityChange;
  final void Function(String?)? onTourismTypeChange;
  final void Function(String?)? onCategoryChange;
  final void Function(String?)? onPopularityChange;
  final VoidCallback onClear;
  final VoidCallback onApply;

  const PlacesDrawer({
    super.key,
    required this.cities,
    required this.tourismTypes,
    required this.categories,
    required this.popularityOptions,
    required this.selectedCity,
    required this.selectedTourismType,
    required this.selectedCategory,
    required this.selectedPopularity,
    required this.onCityChange,
    required this.onTourismTypeChange,
    required this.onCategoryChange,
    required this.onPopularityChange,
    required this.onClear,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'Filter By',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          // City
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
              value: selectedCity,
              items: cities
                  .map((city) => DropdownMenuItem(
                        value: city,
                        child: Text(city,
                            style: GoogleFonts.playfairDisplay(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1),
                      ))
                  .toList(),
              onChanged: onCityChange,
            ),
          ),
          const SizedBox(height: 16),
          // Tourism Type
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Tourism Type',
                border: OutlineInputBorder(),
              ),
              value: selectedTourismType,
              items: tourismTypes
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type,
                        style: GoogleFonts.playfairDisplay(),
                            overflow: TextOverflow.ellipsis, maxLines: 1),
                      ))
                  .toList(),
              onChanged: onTourismTypeChange,
            ),
          ),
          const SizedBox(height: 16),
          // Category
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              value: selectedCategory,
              items: categories
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category,
                        style: GoogleFonts.playfairDisplay(),
                            overflow: TextOverflow.ellipsis, maxLines: 1),
                      ))
                  .toList(),
              onChanged: onCategoryChange,
            ),
          ),
          const SizedBox(height: 16),
          // Popularity
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Popularity',
                border: OutlineInputBorder(),
              ),
              value: selectedPopularity,
              items: popularityOptions
                  .map((popularity) => DropdownMenuItem(
                        value: popularity,
                        child: Text(popularity,
                        style: GoogleFonts.playfairDisplay(),
                            overflow: TextOverflow.ellipsis, maxLines: 1),
                      ))
                  .toList(),
              onChanged: onPopularityChange,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomJoinButton(text: "Clear", onTap: onClear, fontSize: 18),
              CustomJoinButton(text: "Apply", onTap: onApply, fontSize: 18),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
