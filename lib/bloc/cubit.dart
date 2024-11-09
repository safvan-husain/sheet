import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_app/services/api_services.dart';

import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState.initial());


  Future<void> initForm() async {
    String? token = await ApiServices.getAuthToken();
    if (token != null) {
      emit(state.copyWith(authToken: token));
      // var templates = await ApiServices.getTemplateTypes(token);
      var projects = await ApiServices.getProjects(token);
      emit(state.copyWith(
        dropDowns: projects,
        currentDropDown: CurrentDropDown.none
      ));
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

  void selectDate() {}

  void selectProject() async {
    var token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vNDQuMjMzLjExMC4xNzAvYXBpL2FwcC1sb2dpbiIsImlhdCI6MTczMTE0Nzc3MSwiZXhwIjoxNzMxMTkwOTcxLCJuYmYiOjE3MzExNDc3NzEsImp0aSI6InNjeTh1VDF1eVlQaWtDT0IiLCJzdWIiOiIzMTEiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.VlFzWzb0Eo7oJuH78Ng_xCmDDq-kOwyTnsBeM7v4SrI";
    var projects = await ApiServices.getProjects(token);
    emit(state.copyWith(
        dropDowns: projects,
        currentDropDown: CurrentDropDown.projects
    ));
  }

  void clearDropDown() {
    emit(state.copyWith(dropDowns: [], currentDropDown: CurrentDropDown.none));
  }

  void selectTemplateType() {}

  void selectTower() {}

  void selectMilestone() {}

  void selectStartTime() {}

  void selectEndTime() {}

  void toggleTotalBreakHours() {}

  void selectTask() {}

}
