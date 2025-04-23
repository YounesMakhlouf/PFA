import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class TimeFilterDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const TimeFilterDropdown({
    required this.value,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String all = AppLocalizations
        .of(context)
        .periodAll;
    String week = AppLocalizations
        .of(context)
        .periodThisWeek;
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
          items: [
            DropdownMenuItem(value: 'all', child: Text(all)),
            DropdownMenuItem(value: 'week', child: Text(week)),
          ],
          onChanged: onChanged,
          icon: const Icon(Icons.arrow_drop_down_rounded),
          borderRadius: BorderRadius.circular(8),
          dropdownColor: Colors.white, // Dropdown menu background color
        ),
      ),
    );
  }
}
