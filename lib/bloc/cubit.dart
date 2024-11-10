import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:new_app/models/active_task_model.dart';
import 'package:new_app/models/milestone_model.dart';
import 'package:new_app/models/project_model.dart';
import 'package:new_app/models/time_sheet_model.dart';
import 'package:new_app/models/tower_mode.dart';
import 'package:new_app/services/api_services.dart';
import 'package:new_app/utils/date_time_utils.dart';

import '../models/template_model.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState.initial());

  String token =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vNDQuMjMzLjExMC4xNzAvYXBpL2FwcC1sb2dpbiIsImlhdCI6MTczMTIyMjAxNCwiZXhwIjoxNzMxMjY1MjE0LCJuYmYiOjE3MzEyMjIwMTQsImp0aSI6IkdVejdVb2xVSTMza2Q0anEiLCJzdWIiOiIzMTEiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.yMKGGiBUoZKg_uZfGqEnix9M1z5LxXdRjowoYzJX9NM";
  Future<void> initForm() async {
    token = await ApiServices.getAuthToken() ?? "";
    emit(state.copyWith(authToken: token));
    // var templates = await ApiServices.getTemplateTypes(token);
    var projects = await ApiServices.getProjects(token);
    emit(state.copyWith(
        dropDowns: projects, currentDropDown: CurrentDropDown.none));
  }

  Future<List<TimeSheetModel>> getTimeSheetList() async {
    print("time hseet cubit");
    final result = await ApiServices.getTimeSheetList(token);
    return result;

  }

  Future<void> onSubmit({required bool isOnSite, required bool isBreakEnabled}) async {
    var selectedValues = state.selectedValues;
    if (selectedValues.templateData != null &&
        selectedValues.towerData != null &&
        selectedValues.milestoneData != null &&
        selectedValues.projectData != null &&
        state.selectedDate != null &&
        state.selectedStartTime != null &&
        state.selectedEndTime != null) {
      var response = await ApiServices.submitForm(
        authToken: token,
        date: DateTimeUtils.formatDate(state.selectedDate!),
        startTime: DateTimeUtils.formatTimeOfDay(state.selectedStartTime!),
        endTime: DateTimeUtils.formatTimeOfDay(state.selectedEndTime!),
        projectId: state.selectedValues.projectData!.id,
        taskType: isOnSite ? 1 : 0,
        isBreak: isBreakEnabled,
        towerId: state.selectedValues.towerData!.id,
        taskId: state.selectedValues.taskData!.id,
        mileStoneId: state.selectedValues.milestoneData!.id,
        templateId: state.selectedValues.templateData!.id,
        breakTime: null,
      );

      Get.snackbar("Success", "Timesheet saved successfully");
      emit(AppState.initial());
    } else {
      Get.snackbar("Invalid", "Please fill all fields");
    }
  }

  void selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!, // Assuming you're using GetX for navigation
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      emit(state.copyWith(selectedDate: picked));
    }
  }

  void selectProject() async {
    var projects = await ApiServices.getProjects(token);
    emit(
      state.copyWith(
        dropDowns: projects,
        currentDropDown: CurrentDropDown.projects,
      ),
    );
  }

  void clearDropDown() {
    emit(state.copyWith(dropDowns: [], currentDropDown: CurrentDropDown.none));
  }

  void selectTemplateType() async {
    var templates = await ApiServices.getTemplateTypes(token);
    emit(state.copyWith(
      dropDowns: templates,
      currentDropDown: CurrentDropDown.templateType,
    ));
  }

  void selectTower() async {
    if (state.selectedValues.projectData != null &&
        state.selectedValues.templateData != null) {
      var result = await ApiServices.getTowers(
        authToken: token,
        projectId: state.selectedValues.projectData!.id,
        type: 0,
        id: 0,
        templateType: state.selectedValues.templateData!.id,
      );

      emit(
        state.copyWith(
          currentDropDown: CurrentDropDown.tower,
          dropDowns: result,
        ),
      );
    } else {
      Get.snackbar("Invalid", "Please select above fiealds");
    }
  }

  void selectMilestone() async {
    if (state.selectedValues.projectData != null &&
        state.selectedValues.towerData != null) {
      var result = await ApiServices.getMilestones(
        authToken: token,
        towerId: state.selectedValues.towerData!.id,
        projectId: state.selectedValues.projectData!.id,
      );

      emit(state.copyWith(
        dropDowns: result,
        currentDropDown: CurrentDropDown.milestone,
      ));
    } else {
      Get.snackbar("Invalid", "Please select above fiealds");
    }
  }

  void selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      emit(state.copyWith(selectedStartTime: picked));
    }
  }

  void selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      emit(state.copyWith(selectedEndTime: picked));
    }
  }

  void toggleTotalBreakHours() {}

  void selectTask() async {
    if (state.selectedValues.towerData != null &&
        state.selectedValues.projectData != null &&
        state.selectedValues.milestoneData != null) {
      var result = await ApiServices.getTasks(
        authToken: token,
        towerId: state.selectedValues.towerData!.id,
        projectId: state.selectedValues.projectData!.id,
        milestoneId: state.selectedValues.milestoneData!.id,
      );
      emit(state.copyWith(
        dropDowns: result,
        currentDropDown: CurrentDropDown.tasks,
      ));
    } else {
      Get.snackbar("Invalid", "Please select above fiealds");
    }
  }

  void selectItem(int index) {
    switch (state.currentDropDown) {
      case CurrentDropDown.projects:
        emit(
          state.copyWith(
            selectedValues: state.selectedValues
                .copyWith(
                    projectData:
                        state.dropDowns.elementAt(index) as ProjectData)
                .onSelectingProjectData(),
          ),
        );

      case CurrentDropDown.templateType:
        emit(
          state.copyWith(
            selectedValues: state.selectedValues
                .copyWith(
                    templateData:
                        state.dropDowns.elementAt(index) as TemplateData)
                .onSelectingTemplate(),
          ),
        );
      case CurrentDropDown.tower:
        emit(
          state.copyWith(
            selectedValues: state.selectedValues
                .copyWith(
                    towerData: state.dropDowns.elementAt(index) as TowerData)
                .onSelectingTower(),
          ),
        );
      case CurrentDropDown.milestone:
        emit(
          state.copyWith(
            selectedValues: state.selectedValues
                .copyWith(
                    milestoneData:
                        state.dropDowns.elementAt(index) as MilestoneData)
                .onSelectingMilestone(),
          ),
        );
      case CurrentDropDown.tasks:
        emit(
          state.copyWith(
            selectedValues: state.selectedValues.copyWith(
                taskData: state.dropDowns.elementAt(index) as TaskData),
          ),
        );
      case CurrentDropDown.none:
    }
    clearDropDown();
  }
}
