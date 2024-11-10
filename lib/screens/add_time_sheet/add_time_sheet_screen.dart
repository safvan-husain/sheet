import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/bloc/cubit.dart';
import 'package:new_app/main.dart';
import 'package:new_app/screens/add_time_sheet/widgets/select_input.dart';
import 'package:new_app/screens/time_sheet_list/time_sheet_list_screen.dart';
import 'package:new_app/utils/date_time_utils.dart';
import 'package:sizer/sizer.dart';

import '../../bloc/app_state.dart';
import 'widgets/date_time_picker.dart';

class AddTimeSheetScreen extends StatefulWidget {
  const AddTimeSheetScreen({super.key});

  @override
  State<AddTimeSheetScreen> createState() => _AddTimeSheetScreenState();
}

class _AddTimeSheetScreenState extends State<AddTimeSheetScreen> {
  final sheetKey = GlobalKey();
  final projectKey = GlobalKey();
  final templateKey = GlobalKey();
  final towerKey = GlobalKey();
  final milestoneKey = GlobalKey();
  final tasksKey = GlobalKey();
  Offset? projectWidgetPostion;
  RenderBox? projectRenderBox;
  Offset? templateWidgetPosition;
  RenderBox? templateRenderBox;
  Offset? towerWidgetPosition;
  RenderBox? towerRenderBox;
  Offset? mileWidgetPosition;
  RenderBox? mileRenderBox;
  Offset? tasksWidgetPosition;
  RenderBox? tasksRenderBox;
  bool isOtherTask = false;
  double? sheetHeight;

  bool isBreakEnabled = false;

  @override
  Widget build(BuildContext context) {
    calculatePositions();
    return Scaffold(
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
                onTap: () {
                  context.read<AppCubit>().initForm();
                },
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

  Future<Null> calculatePositions() {
    return Future.microtask(() {
      sheetHeight = (sheetKey.currentContext!.findRenderObject() as RenderBox)
          .size
          .height;

      projectRenderBox =
          projectKey.currentContext!.findRenderObject() as RenderBox;
      Offset offset = Offset(0, -(100.h - sheetHeight! - 50));

      projectWidgetPostion = projectRenderBox!.localToGlobal(offset);
      if (isOtherTask) {
      } else {
        templateRenderBox =
            templateKey.currentContext!.findRenderObject() as RenderBox;
        templateWidgetPosition = templateRenderBox!.localToGlobal(offset);
        //---------------
        towerRenderBox =
            towerKey.currentContext!.findRenderObject() as RenderBox;
        towerWidgetPosition = towerRenderBox!.localToGlobal(offset);
        mileRenderBox =
            milestoneKey.currentContext!.findRenderObject() as RenderBox;
        mileWidgetPosition = mileRenderBox!.localToGlobal(offset);
        tasksRenderBox =
            tasksKey.currentContext!.findRenderObject() as RenderBox;
        tasksWidgetPosition = tasksRenderBox!.localToGlobal(offset);
      }
    });
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Get.to(() => const TimeSheetListScreen());
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
        child: Text(
      "Add time sheet",
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    ));
  }

  _buildSheet() {
    return GestureDetector(
      key: sheetKey,
      onTap: () {
        context.read<AppCubit>().clearDropDown();
      },
      child: Container(
        width: 100.w,
        height: sheetHeight,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DateTimeSelector(
                      title: "Select Date",
                      value: state.selectedDate == null
                          ? "Select"
                          : DateTimeUtils.formatDate(state.selectedDate!),
                      selector: context.read<AppCubit>().selectDate,
                      icon: Icons.calendar_month,
                    ),
                    _buildOnsiteChooser(),
                    SelectInputBox(
                      value: state.selectedValues.projectData?.name,
                      onTap: () {
                        context.read<AppCubit>().selectProject();
                      },
                      key: projectKey,
                      title: "Select Project",
                      icon: Icons.arrow_drop_down,
                    ),
                    if (isOtherTask) ...[
                      SelectInputBox(
                        value: "Select",
                        onTap: () {},
                        key: templateKey,
                        title: "Other task not implemented",
                        icon: Icons.arrow_drop_down,
                      ),
                    ] else ...[
                      SelectInputBox(
                        value: state.selectedValues.templateData?.name,
                        onTap: () {
                          context.read<AppCubit>().selectTemplateType();
                        },
                        key: templateKey,
                        title: "Select Template Type",
                        icon: Icons.arrow_drop_down,
                      ),
                      SelectInputBox(
                        value: state.selectedValues.towerData?.name,
                        onTap: () {
                          context.read<AppCubit>().selectTower();
                        },
                        key: towerKey,
                        title: "Select Tower",
                        icon: Icons.arrow_drop_down,
                      ),
                      SelectInputBox(
                        value: state.selectedValues.milestoneData?.name,
                        onTap: () {
                          context.read<AppCubit>().selectMilestone();
                        },
                        key: milestoneKey,
                        title: "Select Milestone",
                        icon: Icons.arrow_drop_down,
                      ),
                      SelectInputBox(
                        value: state.selectedValues.taskData?.name,
                        onTap: () {
                          context.read<AppCubit>().selectTask();
                        },
                        key: tasksKey,
                        title: "Select Tasks",
                        icon: Icons.arrow_drop_down,
                      ),
                    ],
                    _buildStartEndPickers(state),
                    _buildBreakTimeChooser(),
                    if (isOtherTask) ...[
                      const Spacer(),
                      InkWell(
                        onTap: () async {
                          await context.read<AppCubit>().onSubmit(
                                isOnSite: false,
                                isBreakEnabled: isBreakEnabled,
                              );
                          setState(() {
                            isOtherTask = false;
                            isBreakEnabled = false;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10, top: 20),
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 5, 170),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Save & Add more",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
                if (state.currentDropDown != CurrentDropDown.none)
                  Positioned(
                    top: getTopPositionBasedSelectedDropDown(state),
                    left: getLeftPositionBasedSelectedDropDown(state),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        border: Border.all(color: Colors.grey),
                        color: Colors.white,
                      ),
                      height: state.dropDowns.length > 3
                          ? 150
                          : state.dropDowns.length * 50,
                      width: projectRenderBox!.size.width,
                      child: ListView.builder(
                        itemCount: state.dropDowns.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              context.read<AppCubit>().selectItem(index);
                            },
                            child: ListTile(
                              title: Text(
                                state.dropDowns.elementAt(index).name,
                                style: GoogleFonts.poppins(fontSize: 11),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  double getLeftPositionBasedSelectedDropDown(AppState state) {
    return switch (state.currentDropDown) {
      CurrentDropDown.projects => projectWidgetPostion!.dx - 20,
      CurrentDropDown.templateType => templateWidgetPosition!.dx - 20,
      CurrentDropDown.tower => towerWidgetPosition!.dx - 20,
      CurrentDropDown.milestone => mileWidgetPosition!.dx - 20,
      CurrentDropDown.tasks => tasksWidgetPosition!.dx - 20,
      CurrentDropDown.none => 0,
    };
  }

  double getTopPositionBasedSelectedDropDown(AppState state) {
    return switch (state.currentDropDown) {
      CurrentDropDown.projects => projectWidgetPostion!.dy,
      CurrentDropDown.templateType => templateWidgetPosition!.dy,
      CurrentDropDown.tower => towerWidgetPosition!.dy,
      CurrentDropDown.milestone => mileWidgetPosition!.dy,
      CurrentDropDown.tasks => tasksWidgetPosition!.dy,
      CurrentDropDown.none => 0,
    };
  }

  _buildOnsiteChooser() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "On site",
            style: GoogleFonts.poppins(fontSize: 11),
          ),
          const SizedBox(
            width: 20,
          ),
          Switch(
            value: isOtherTask,
            onChanged: (value) {
              setState(() {
                isOtherTask = value;
              });
            },
            activeTrackColor: Colors.amber,
            inactiveTrackColor: const Color.fromARGB(255, 10, 5, 170),
            thumbColor: const WidgetStatePropertyAll(Colors.white),
            trackOutlineColor: const WidgetStatePropertyAll(
              Colors.white,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            "Other task",
            style: GoogleFonts.poppins(fontSize: 11),
          ),
        ],
      ),
    );
  }

  _buildBreakTimeChooser() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(15, 0, 15, 45),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Total break time hours",
              style: GoogleFonts.poppins(fontSize: 11)),
          Switch(
            value: isBreakEnabled,
            onChanged: (value) {
              setState(() {
                isBreakEnabled = value;
              });
            },
            activeTrackColor: const Color.fromARGB(255, 10, 5, 170),
            inactiveTrackColor: Colors.grey,
            thumbColor: const WidgetStatePropertyAll(Colors.white),
            trackOutlineColor: const WidgetStatePropertyAll(
              Color.fromARGB(15, 0, 15, 450),
            ),
          ),
        ],
      ),
    );
  }

  _buildStartEndPickers(AppState state) {
    return SizedBox(
      width: 100.w,
      child: Row(
        children: [
          Expanded(
            child: DateTimeSelector(
              title: "Start time",
              value: state.selectedStartTime == null
                  ? "Select"
                  : DateTimeUtils.formatTimeOfDay(state.selectedStartTime!),
              selector: () async {
                context.read<AppCubit>().selectStartTime();
              },
              icon: Icons.watch_later_rounded,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: DateTimeSelector(
              value: state.selectedEndTime == null
                  ? "Select"
                  : DateTimeUtils.formatTimeOfDay(state.selectedEndTime!),
              title: "End time",
              selector: () async {
                context.read<AppCubit>().selectEndTime();
              },
              icon: Icons.watch_later_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
