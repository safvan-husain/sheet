import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/bloc/cubit.dart';
import 'package:sizer/sizer.dart';

import '../../models/time_sheet_model.dart';
import 'widgets/time_sheet_tile.dart';

class TimeSheetListScreen extends StatefulWidget {
  const TimeSheetListScreen({super.key});

  @override
  State<TimeSheetListScreen> createState() => _TimeSheetListScreenState();
}

class _TimeSheetListScreenState extends State<TimeSheetListScreen> {
  late Future<List<TimeSheetModel>> futureList;

  @override
  void initState() {
    futureList = context.read<AppCubit>().getTimeSheetList();
    controller.addListener(() {
      if (controller.text.isEmpty) {
        filteredData = data;
      } else {
        filteredData = data
            .where((e) => e.projectName.toLowerCase().startsWith(controller.text.toLowerCase()))
            .toList();
      }
      setState(() {});
    });
    super.initState();
  }

  TextEditingController controller = TextEditingController();
  List<TimeSheetModel> data = [];

  List<TimeSheetModel> filteredData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 10, 5, 170),
      body: SafeArea(
        child: SizedBox(
          height: 100.h,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAppBar(),
              GestureDetector(
                onTap: () {},
                child: _buildTitle(),
              ),
              // Spacer(),
              _buildSheet()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: const CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 15,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const Spacer(),
          const Icon(Icons.contact_emergency),
          const Icon(Icons.arrow_drop_down)
        ],
      ),
    );
  }

  _buildTitle() {
    return Center(
        child: InkWell(
      onTap: () {
        setState(() {
          futureList = context.read<AppCubit>().getTimeSheetList();
        });
      },
      child: Text(
        "Time sheet list",
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    ));
  }

  _buildSheet() {
    return Container(
      width: 100.w,
      height: 83.h,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: const Color.fromARGB(15, 0, 15, 45),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search",
                hintStyle: GoogleFonts.poppins(fontSize: 11),
                icon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder(
              future: futureList,
              builder: (context, snp) {
                if (snp.connectionState != ConnectionState.done && !snp.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (data.isEmpty) {
                  data = snp.data!;
                  filteredData = data;
                }
            
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    var item = filteredData.elementAt(index);
                    return TimeSheetTile(
                      name: item.projectName,
                      date: "24-101299",
                      breakTime: item.breakTime,
                      onSite: item.hrs,
                      milestone: "Nothing",
                      template: "Nothing",
                      tower: "hv4",
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}


