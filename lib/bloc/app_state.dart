import 'package:flutter/material.dart';
import 'package:new_app/models/active_task_model.dart';
import 'package:new_app/models/milestone_model.dart';
import 'package:new_app/models/project_model.dart';
import 'package:new_app/models/tower_mode.dart';
import 'package:new_app/services/api_services.dart';

enum CurrentDropDown { projects, templateType, tower, milestone, tasks, none }

class SelectedValues {
  final ProjectData? projectData;
  final TemplateData? templateData;
  final TowerData? towerData;
  final MilestoneData? milestoneData;
  final TaskData? taskData;

  SelectedValues({
    this.projectData,
    this.templateData,
    this.towerData,
    this.milestoneData,
    this.taskData,
  });

  SelectedValues copyWith({
    ProjectData? projectData,
    TemplateData? templateData,
    TowerData? towerData,
    MilestoneData? milestoneData,
    TaskData? taskData,
  }) {
    return SelectedValues(
      projectData: projectData ?? this.projectData,
      templateData: templateData ?? this.templateData,
      towerData: towerData ?? this.towerData,
      milestoneData: milestoneData ?? this.milestoneData,
      taskData: taskData ?? this.taskData,
    );
  }
}

class AppState {
  final CurrentDropDown currentDropDown;
  final String? authToken;
  final List<DropDownData> dropDowns;
  final bool isOnsite;
  final DateTime? selectedDate;
  final TimeOfDay? selectedStartTime;
  final TimeOfDay? selectedEndTime;
  final bool isTotalBreakTimeHourEnabled;
  final SelectedValues selectedValues;

  AppState({
    this.authToken,
    required this.currentDropDown,
    required this.dropDowns,
    required this.isOnsite,
    required this.isTotalBreakTimeHourEnabled,
    this.selectedDate,
    this.selectedStartTime,
    this.selectedEndTime,
    required this.selectedValues,
  });

  factory AppState.initial() {
    return AppState(
        selectedValues: SelectedValues(),
        dropDowns: [],
        isOnsite: true,
        currentDropDown: CurrentDropDown.none,
        isTotalBreakTimeHourEnabled: false);
  }

  AppState copyWith(
      {String? authToken,
      List<DropDownData>? dropDowns,
      bool? isOnsite,
      DateTime? selectedDate,
      TimeOfDay? selectedStartTime,
      TimeOfDay? selectedEndTime,
      bool? isTotalBreakTimeHourEnabled,
      CurrentDropDown? currentDropDown,
      SelectedValues? selectedValues}) {
    return AppState(
        currentDropDown: currentDropDown ?? this.currentDropDown,
        authToken: authToken ?? this.authToken,
        isTotalBreakTimeHourEnabled:
            isTotalBreakTimeHourEnabled ?? this.isTotalBreakTimeHourEnabled,
        dropDowns: dropDowns ?? this.dropDowns,
        isOnsite: isOnsite ?? this.isOnsite,
        selectedDate: selectedDate ?? this.selectedDate,
        selectedEndTime: selectedEndTime ?? this.selectedEndTime,
        selectedStartTime: selectedStartTime ?? this.selectedStartTime,
        selectedValues: selectedValues ?? this.selectedValues);
  }
}

abstract class DropDownData {
  final String name;
  final int id;

  DropDownData({required this.name, required this.id});
}
