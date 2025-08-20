import 'package:flutter/material.dart';
import '../models/app_category.dart';

class CategoryChipBar extends StatelessWidget {
  final List<AppCategory> categories;
  final String? selectedId;
  final void Function(String?) onSelected;
  const CategoryChipBar({super.key, required this.categories, required this.selectedId, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: const Text('Todos'),
          selected: selectedId == null,
          onSelected: (_) => onSelected(null),
        ),
        for (final c in categories.where((e) => e.id != '0'))
          ChoiceChip(
            label: Text(c.nombre),
            selected: selectedId == c.id,
            onSelected: (_) => onSelected(c.id),
          ),
      ],
    );
  }
}
