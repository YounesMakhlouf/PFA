import 'package:flutter/material.dart';
import 'package:pfa/config/app_theme.dart';
import '../l10n/app_localizations.dart';

class TimeFilterDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const TimeFilterDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    String all = AppLocalizations
        .of(context)
        .all;
    String week = AppLocalizations
        .of(context)
        .periodThisWeek;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightGrey,
          width: 1.0,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: [
            DropdownMenuItem(value: 'all', child: Text(all, style: Theme.of(context).textTheme.bodyLarge)),
            DropdownMenuItem(value: 'week', child: Text(week,style: Theme.of(context).textTheme.bodyLarge)),
          ],
          onChanged: onChanged,
          icon: const Icon(Icons.arrow_drop_down_rounded),
          borderRadius: BorderRadius.circular(8),
          dropdownColor: AppColors.lightGrey,
        ),
      ),
    );
  }
}
