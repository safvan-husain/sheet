import 'package:flutter/material.dart';

class DateTimeSelector extends StatelessWidget {
  final String title;
  final Future<String> Function() selector;

  final IconData icon;
  const DateTimeSelector({
    super.key,
    required this.title,
    required this.selector, required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    String? selectedValue;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Text(title),
        ),
        GestureDetector(
          onTap: () async {
            selectedValue = await selector();
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(selectedValue ?? "Select"),
                Icon(icon)
              ],
            ),
          ),
        )
      ],
    );
  }
}
