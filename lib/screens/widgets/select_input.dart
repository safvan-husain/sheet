import 'package:flutter/material.dart';

class SelectInputBox extends StatelessWidget {
  final String title;
  final int? selectedIndex;
  final List<String> dropDownValues;
  final IconData icon;
  final void Function() onTap;

  const SelectInputBox({
    super.key,
    required this.onTap,
    required this.title,
    required this.dropDownValues,
    required this.selectedIndex,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedIndex == null
                      ? "select "
                      : dropDownValues.elementAt(selectedIndex!),
                ),
                Icon(icon),
              ],
            ),
          ),
        )
      ],
    );
  }
}
