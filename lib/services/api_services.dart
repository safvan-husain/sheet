import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:new_app/models/active_task_model.dart';
import 'package:new_app/models/milestone_model.dart';
import 'package:new_app/models/tower_mode.dart';

import '../models/project_model.dart';

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

  static Future<void> getTemplateTypes2(String authToken) async {
    print(authToken);
    var url = Uri.parse(
      "http://44.233.110.170/api/template-types",
    );
    var response = await http.post(
      url,
      headers: {"Authorization": "Bearer " + authToken},
      body: jsonEncode({
        "company_id": 49,
        "type": 0,
        "id": 0,
      }),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
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
      // var data = jsonDecode(response.data);

      for (var item in response.data) {
        print(item);
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
        print(item);
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
        print(item);
        result.add(MilestoneData.fromJson(item));
      }
    }
    return result;
  }

  static Future<List<TaskData>> getTasks({
    required String authToken,
    required int towerId,
    required int projectId,
    required int milestoneId
  }) async {
    List<TaskData> result = [];
    final response = await dio.get(
      "http://44.233.110.170/api/active-tasks/$towerId/$milestoneId/$projectId",
      options: Options(
          preserveHeaderCase: true,
          headers: {"Authorization": "Bearer $authToken"}),

    );

    if (response.statusCode == 200) {
      for (var item in response.data) {
        print(item);
        result.add(TaskData.fromJson(item));
      }
    }
    return result;
  }
}

//TODO
class TemplateData {
  final String templateName;
  final int id;

  TemplateData({required this.templateName, required this.id});

  Map<String, dynamic> toMap() {
    return {
      'template_name': templateName,
      'id': id,
    };
  }

  factory TemplateData.fromMap(Map<String, dynamic> map) {
    return TemplateData(
      templateName: map['template_name'] as String,
      id: map['id'] as int,
    );
  }
}
