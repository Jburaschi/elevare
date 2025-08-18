import 'package:flutter/material.dart';
import '../models/app_category.dart' as app_models;

class CategoryChipBar extends StatelessWidget {
  final List<app_models.AppCategory> categories;
  final int? selectedId;
  final void Function(int?) onSelected;
  const CategoryChipBar({super.key, required this.categories, required this.selectedId, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: const Text('Todas'),
              selected: selectedId == null,
              onSelected: (_) => onSelected(null),
            ),
          ),
          ...categories.map((c) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(c.nombre),
                  selected: selectedId == c.id,
                  onSelected: (_) => onSelected(c.id),
                ),
              )),
        ],
      ),
    );
  }
}
