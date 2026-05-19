import 'package:etrip/core/widgets/space_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final T value;
  final void Function(T?) onChanged;
  final String? Function(T)? itemLabelBuilder;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    this.itemLabelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                color: const Color.fromARGB(255, 1, 44, 80),
                fontSize: 15,
                fontWeight: FontWeight.bold)),
        const VerticalSpace(0.5),
        DropdownButtonFormField<T>(
          dropdownColor: Colors.white,
          value: value,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
          ),
          onChanged: onChanged,
          items: items
              .map((e) => DropdownMenuItem<T>(
                    value: e,
                    child: Text(
                      itemLabelBuilder != null
                          ? itemLabelBuilder!(e) ?? e.toString()
                          : "$e".toString()[0].toUpperCase() +
                              "$e".toString().substring(1),
                      style: GoogleFonts.lato(),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
