import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class TimeSheetTile extends StatelessWidget {
  final String name;
  final String date;
  final String onSite;
  final String breakTime;
  final String milestone;
  final String template;
  final String tower;
  const TimeSheetTile({
    super.key,
    required this.name,
    required this.date,
    required this.onSite,
    required this.breakTime,
    required this.milestone,
    required this.template,
    required this.tower,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2), // Shadow color
                spreadRadius: 2, // Spread radius
                blurRadius: 5, // Blur radius
                offset: const Offset(0, 3), // Offset in the x and y direction
              ),
            ],
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.ac_unit),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        date,
                        style: GoogleFonts.poppins(fontSize: 11),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildit(onSite, "Total onsite"),
                      buildit(breakTime, "Total break time"),
                    ],
                  ),
                  Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildit(milestone, "Milestone"),
                      buildit(template, "Template"),
                    ],
                  ),
                  Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buildit(tower, "Tower", 15.w),
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

Widget buildit(String tile, String desc, [double? width]) {
  return Container(
    width: width,
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tile,
          style: GoogleFonts.poppins(fontSize: 12),
        ),
        Text(
          desc,
          style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w200),
        ),
      ],
    ),
  );
}