import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DateTimeSelector extends StatelessWidget {
  final String title;
  final void Function() selector;
  final String? value;

  final IconData icon;
  const DateTimeSelector({
    super.key,
    required this.title,
    required this.value,
    required this.selector, required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    String? selectedValue;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(title,
            style: GoogleFonts.poppins(fontSize: 11),),
          ),
          GestureDetector(
            onTap: selector,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(15, 0, 15, 45),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(value == null ? "Select" : value!,  style: GoogleFonts.poppins(fontSize: 11)),
                  Icon(icon, color: Colors.grey,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
