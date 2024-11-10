import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectInputBox extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function() onTap;
  final String? value;

  const SelectInputBox({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(title, style: GoogleFonts.poppins(fontSize: 11),),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(15, 0, 15, 45),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value == null ? "Select" : value!,
                    style: GoogleFonts.poppins(fontSize: 11),
                  ),
                  Icon(icon),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
