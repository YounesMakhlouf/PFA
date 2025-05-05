import 'package:flutter/material.dart';
import 'package:pfa/models/CategoryOption.dart';

class CategoryDropdown extends StatelessWidget {
  final String value;
  final List<CategoryOption> categories;
  final ValueChanged<String?> onChanged;

  const CategoryDropdown({
    required this.value,
    required this.categories,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200, // Background color
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade200, // Border color
          width: 1.0,
        ),
      ),
      child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            items: categories.map((category) {
              return DropdownMenuItem<String>(
                value: category.value,
                child: Text(category.label),
              );
            }).toList(),
            onChanged: onChanged,
            underline: Container(),
            icon: const Icon(Icons.arrow_drop_down_rounded),
          )
      ),
    );
  }
}