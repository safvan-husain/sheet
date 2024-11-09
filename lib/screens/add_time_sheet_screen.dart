import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_app/bloc/cubit.dart';
import 'package:new_app/main.dart';
import 'package:new_app/screens/widgets/select_input.dart';
import 'package:sizer/sizer.dart';

import '../bloc/app_state.dart';
import 'widgets/date_time_picker.dart';

class AddTimeSheetScreen extends StatefulWidget {
  const AddTimeSheetScreen({super.key});

  @override
  State<AddTimeSheetScreen> createState() => _AddTimeSheetScreenState();
}

class _AddTimeSheetScreenState extends State<AddTimeSheetScreen> {
  final projectKey = GlobalKey();
  final templateKey = GlobalKey();
  final towerKey = GlobalKey();
  final milestoneKey = GlobalKey();
  final tasksKey = GlobalKey();
  Offset? projectWidgetPostion;
  RenderBox? projectRenderBox;
  Offset? templateWidgetPostion;
  RenderBox? templateRenderBox;
  Offset? towerWidgetPostion;
  RenderBox? towerRenderBox;
  Offset? mileWidgetPostion;
  RenderBox? mileRenderBox;
  Offset? tasksWidgetPostion;
  RenderBox? tasksRenderBox;

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      if (projectWidgetPostion != null) return;
      projectRenderBox =
          projectKey.currentContext!.findRenderObject() as RenderBox;
      projectWidgetPostion = projectRenderBox!.localToGlobal(Offset.zero);
      templateRenderBox =
          templateKey.currentContext!.findRenderObject() as RenderBox;
      templateWidgetPostion = templateRenderBox!.localToGlobal(Offset.zero);
      //---------------
      towerRenderBox =
          towerKey.currentContext!.findRenderObject() as RenderBox;
      towerWidgetPostion = towerRenderBox!.localToGlobal(Offset.zero);
      mileRenderBox =
          milestoneKey.currentContext!.findRenderObject() as RenderBox;
      mileWidgetPostion = mileRenderBox!.localToGlobal(Offset.zero);
      tasksRenderBox =
          tasksKey.currentContext!.findRenderObject() as RenderBox;
      tasksWidgetPostion = tasksRenderBox!.localToGlobal(Offset.zero);
      setState(() {});
    });
    return Scaffold(
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              GestureDetector(
                onTap: () {
                  context.read<AppCubit>().initForm();
                },
                child: _buildTitle(),
              ),
              _buildSheet()
            ],
          ),
        ));
  }

  Widget _buildAppBar() {
    return const Row(
      children: [
        Icon(Icons.arrow_circle_left_rounded),
        Spacer(),
        Icon(Icons.contact_emergency),
        Icon(Icons.arrow_drop_down)
      ],
    );
  }

  _buildTitle() {
    return const Center(child: Text("Add time sheet"));
  }

  _buildSheet() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          print("parent detector");
          context.read<AppCubit>().clearDropDown();
        },
        child: Container(
          width: 100.w,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: BlocBuilder<AppCubit, AppState>(
            builder: (context, state) {
              return Stack(
                children: [
                  Column(
                    children: [
                      DateTimeSelector(
                        title: "Select Date",
                        selector: () async {
                          return "Selected Date";
                        },
                        icon: Icons.calendar_month,
                      ),
                      _buildOnsiteChooser(),
                      SelectInputBox(
                        onTap: () {
                          print("on tap");
                          context.read<AppCubit>().selectProject();
                        },
                        key: projectKey,
                        title: "Select Project",
                        dropDownValues: const [],
                        selectedIndex: null,
                        icon: Icons.arrow_drop_down,
                      ),
                      SelectInputBox(
                        onTap: () {
                          print("on tap");
                          context.read<AppCubit>().selectTemplateType();
                        },
                        key: templateKey,
                        title: "Select Template Type",
                        dropDownValues: const [],
                        selectedIndex: null,
                        icon: Icons.arrow_drop_down,
                      ),
                      SelectInputBox(
                        onTap: () {
                          print("on tap");
                          context.read<AppCubit>().selectMilestone();
                        },
                        key: milestoneKey,
                        title: "Select Milestone",
                        dropDownValues: const [],
                        selectedIndex: null,
                        icon: Icons.arrow_drop_down,
                      ),
                      SelectInputBox(
                        onTap: () {
                          print("on tap");
                          context.read<AppCubit>().selectTask();
                        },
                        key: tasksKey,
                        title: "Select Tasks",
                        dropDownValues: const [],
                        selectedIndex: null,
                        icon: Icons.arrow_drop_down,
                      ),
                      _buildStartEndPickers(),
                      _buildBreakTimeChooser(),
                    ],
                  ),
                  if (projectWidgetPostion != null &&
                      projectRenderBox != null &&
                      state.currentDropDown == CurrentDropDown.projects)
                    Positioned(
                      top: projectWidgetPostion!.dy - 10,
                      left: projectWidgetPostion!.dx - 10,
                      child: Container(
                        color: Colors.red,
                        height: 100,
                        width: projectRenderBox!.size.width,
                        child: BlocBuilder<AppCubit, AppState>(
                          builder: (context, state) {
                            return ListView.builder(
                              itemCount: state.dropDowns.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                      state.dropDowns.elementAt(index).name),
                                );
                              },
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
      ),
    );
  }

  _buildOnsiteChooser() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("On site"),
          Switch(
            value: false,
            onChanged: (va) {},
          ),
          Text("Other task"),
        ],
      ),
    );
  }

  _buildBreakTimeChooser() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Select"),
          Switch(value: false, onChanged: (_) {}),
        ],
      ),
    );
  }

  _buildStartEndPickers() {
    return SizedBox(
      width: 100.w,
      child: Row(
        children: [
          DateTimeSelector(
            title: "Select Date",
            selector: () async {
              return "Selected Date";
            },
            icon: Icons.calendar_month,
          ),
          DateTimeSelector(
            title: "Select Date",
            selector: () async {
              return "Selected Date";
            },
            icon: Icons.calendar_month,
          ),
        ],
      ),
    );
  }
}
