import 'package:flutter/material.dart';

class MacroBarWidget extends StatelessWidget {
  final String label;
  final double? value;
  final double maxValue;
  final Color color;
  final String unit;

  const MacroBarWidget({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
    this.unit = 'g',
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = value;
    final fraction = displayValue != null
        ? (displayValue / maxValue).clamp(0.0, 1.0)
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 13)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fraction,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 10,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 52,
            child: Text(
              displayValue != null
                  ? '${displayValue.toStringAsFixed(1)}$unit'
                  : '—',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
