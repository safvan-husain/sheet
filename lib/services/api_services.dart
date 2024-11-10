import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:new_app/models/active_task_model.dart';
import 'package:new_app/models/milestone_model.dart';
import 'package:new_app/models/time_sheet_model.dart';
import 'package:new_app/models/tower_mode.dart';

import '../models/project_model.dart';
import '../models/template_model.dart';

class ApiServices {
  static final Dio dio = Dio();

  static Future<String?> getAuthToken() async {
    final response = await dio.post("http://44.233.110.170/api/app-login",
        data: {
          "email": "ishtechdeveloper10+team1@gmail.com",
          "password": "123456"
        });

    if (response.statusCode == 200) {
      return response.data["access_token"];
    }
    return null;
  }


  static Future<List<TimeSheetModel>> getTimeSheetList(String authToken) async {
    print("time sheet called");
    List<TimeSheetModel> result = [];
    dio.options.validateStatus = (s) => true;
    late var response;
    try {
      response = await dio.post("http://44.233.110.170/api/list-timesheet",
          options: Options(
              preserveHeaderCase: true,
              headers: {"Authorization": "Bearer $authToken"}),
          data: {
            "date": "2024-04-30",
            "user_id": 453
          });
      print("after dio");
    } catch (e) {
      print(e);
    }

    // throw "reach here";

    if(response.statusCode == 200) {
      for (var data in response.data) {
        print(data);
        try {
          result.add(TimeSheetModel.fromMap(data));
        } catch (e) {
          print(e);
        }

        print(result);
      }
    }
    print("data below");
    print(response.data);
    return result;
  }


  static Future<List<ProjectData>> getProjects(String authToken) async {
    List<ProjectData> result = [];
    // dio.options.headers['Authorization'] = authToken;
    final response = await dio.get(
      "http://44.233.110.170/api/active-project/311/0",
      options: Options(
          preserveHeaderCase: true,
          headers: {"Authorization": "Bearer $authToken"}),
    );

    if (response.statusCode == 200) {
      // var data = jsonDecode(response.data);

      for (var item in response.data) {
        print(item);
        result.add(ProjectData.fromJson(item));
      }
    }
    return result;
  }

  static Future<List<TemplateData>> getTemplateTypes(String authToken) async {
    List<TemplateData> result = [];
    // dio.options.headers['Authorization'] = authToken;
    final response = await dio.post(
      "http://44.233.110.170/api/template-types",
      options: Options(
          preserveHeaderCase: true,
          headers: {"Authorization": "Bearer $authToken"}),
      data: {
        "company_id": 49,
        "type": 0,
        "id": 0,
      },
    );

    if (response.statusCode == 200) {
      for (var item in response.data) {
        result.add(TemplateData.fromMap(item));
      }
    }
    return result;
  }

  static Future<List<TowerData>> getTowers({
    required String authToken,
    required int projectId,
    required int type,
    required int id,
    required int templateType,
  }) async {
    List<TowerData> result = [];
    final response = await dio.post(
      "http://44.233.110.170/api/active-tower",
      options: Options(
          preserveHeaderCase: true,
          headers: {"Authorization": "Bearer $authToken"}),
      data: {
        "project_id": projectId,
        "type": type,
        "id": id,
        "template_type": templateType
      },
    );

    if (response.statusCode == 200) {
      for (var item in response.data) {
        result.add(TowerData.fromJson(item));
      }
    }
    return result;
  }

  static Future<List<MilestoneData>> getMilestones({
    required String authToken,
    required int towerId,
    required int projectId,
  }) async {
    List<MilestoneData> result = [];
    final response = await dio.get(
      "http://44.233.110.170/api/active-milestones/$towerId/$projectId",
      options: Options(
          preserveHeaderCase: true,
          headers: {"Authorization": "Bearer $authToken"}),
    );

    if (response.statusCode == 200) {
      for (var item in response.data) {
        result.add(MilestoneData.fromJson(item));
      }
    }
    return result;
  }

  static Future<List<TaskData>> getTasks(
      {required String authToken,
      required int towerId,
      required int projectId,
      required int milestoneId}) async {
    List<TaskData> result = [];
    final response = await dio.get(
      "http://44.233.110.170/api/active-tasks/$towerId/$milestoneId/$projectId",
      options: Options(
          preserveHeaderCase: true,
          headers: {"Authorization": "Bearer $authToken"}),
    );

    if (response.statusCode == 200) {
      for (var item in response.data) {
        result.add(TaskData.fromJson(item));
      }
    }
    return result;
  }

  static Future<void> submitForm({
    required String date,
    required String startTime,
    required String endTime,
    required int projectId,
    required int taskType,
    required bool isBreak,
    required int towerId,
    required int taskId,
    required int mileStoneId,
    required int templateId,
    int? otherTaskId,
    required String? breakTime,
    required String authToken,
  }) async {
    dio.options.validateStatus = (s) => true;

    var data = {
      "id": 0,
      "user_id": 311,
      "date": date,
      "start_time": startTime,
      "end_time": endTime,
      "project_id": projectId,
      "task_type": 1,
      "break": 0,
      "tower_id": towerId,
      "task_id": taskId,
      "milestone_id": mileStoneId,
      "template_type": templateId,
      "other_task_id": otherTaskId,
      "break_time": null
    };
    var response = await dio.post(
      "http://44.233.110.170/api/daily-time-sheet",
      options: Options(
          preserveHeaderCase: true,
          headers: {"Authorization": "Bearer $authToken"}),
      data: data,
    );

    print(response.statusCode);
    print(response.data);
  }
}

//TODO

