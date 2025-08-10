import 'package:flutter/material.dart';

class DropdownsRow extends StatelessWidget {
  final String viewType;
  final int selectedMonth;
  final List<String> viewTypes;
  final List<String> months;
  final ValueChanged<String?> onViewTypeChanged;
  final ValueChanged<int?> onMonthChanged;

  const DropdownsRow({
    super.key,
    required this.viewType,
    required this.selectedMonth,
    required this.viewTypes,
    required this.months,
    required this.onViewTypeChanged,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton<String>(
          value: viewType,
          items: viewTypes
              .map((type) => DropdownMenuItem(value: type, child: Text(type)))
              .toList(),
          onChanged: onViewTypeChanged,
        ),
        if (viewType == 'Bulanan') ...[
          const SizedBox(width: 16),
          DropdownButton<int>(
            value: selectedMonth,
            items: List.generate(
              12,
              (i) => DropdownMenuItem(value: i, child: Text(months[i])),
            ),
            onChanged: onMonthChanged,
          ),
        ],
      ],
    );
  }
}
