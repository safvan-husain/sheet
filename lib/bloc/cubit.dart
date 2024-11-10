import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:new_app/models/active_task_model.dart';
import 'package:new_app/models/milestone_model.dart';
import 'package:new_app/models/project_model.dart';
import 'package:new_app/models/tower_mode.dart';
import 'package:new_app/services/api_services.dart';

import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState.initial());

  var token =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vNDQuMjMzLjExMC4xNzAvYXBpL2FwcC1sb2dpbiIsImlhdCI6MTczMTE0Nzc3MSwiZXhwIjoxNzMxMTkwOTcxLCJuYmYiOjE3MzExNDc3NzEsImp0aSI6InNjeTh1VDF1eVlQaWtDT0IiLCJzdWIiOiIzMTEiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.VlFzWzb0Eo7oJuH78Ng_xCmDDq-kOwyTnsBeM7v4SrI";
  Future<void> initForm() async {
    String? token = await ApiServices.getAuthToken();
    if (token != null) {
      emit(state.copyWith(authToken: token));
      // var templates = await ApiServices.getTemplateTypes(token);
      var projects = await ApiServices.getProjects(token);
      emit(state.copyWith(
          dropDowns: projects, currentDropDown: CurrentDropDown.none));
    } else {
      //throw todo
    }
  }

  void test() async {
    String? token = await ApiServices.getAuthToken();
    if (token != null) {
      var templates = await ApiServices.getTemplateTypes(token);
      var projects = await ApiServices.getProjects(token);
      var towers = await ApiServices.getTowers(
        authToken: token,
        projectId: projects.first.id!,
        type: 0,
        id: 0,
        templateType: templates.first.id,
      );

      var milestones = await ApiServices.getMilestones(
        authToken: token,
        towerId: towers.first.id!,
        projectId: projects.first.id!,
      );

      var tasks = await ApiServices.getTasks(
        authToken: token,
        towerId: towers.first.id!,
        projectId: projects.first.id!,
        milestoneId: milestones.first.id!,
      );
      print(tasks);
      //get other data
    } else {
      print("eror at a423972");
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
    emit(state.copyWith(
        dropDowns: projects, currentDropDown: CurrentDropDown.projects));
  }

  void clearDropDown() {
    emit(state.copyWith(dropDowns: [], currentDropDown: CurrentDropDown.none));
  }

  void selectTemplateType() async {
    var templates = await ApiServices.getTemplateTypes(token);
    emit(state.copyWith(
        dropDowns: templates, currentDropDown: CurrentDropDown.templateType));
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

      emit(state.copyWith(
          currentDropDown: CurrentDropDown.tower, dropDowns: result));
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
            selectedValues: state.selectedValues.copyWith(
                projectData: state.dropDowns.elementAt(index) as ProjectData),
          ),
        );

      case CurrentDropDown.templateType:
        emit(
          state.copyWith(
            selectedValues: state.selectedValues.copyWith(
                templateData: state.dropDowns.elementAt(index) as TemplateData),
          ),
        );
      case CurrentDropDown.tower:
        emit(
          state.copyWith(
            selectedValues: state.selectedValues.copyWith(
                towerData: state.dropDowns.elementAt(index) as TowerData),
          ),
        );
      case CurrentDropDown.milestone:
        emit(
          state.copyWith(
            selectedValues: state.selectedValues.copyWith(
                milestoneData:
                    state.dropDowns.elementAt(index) as MilestoneData),
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
