class TimeSheetModel {
  int id;
  String projectName;
  String hrs;
  String breakTime;
  int taskType;
  String? taskName;
  String? otherTaskName;

  TimeSheetModel({
    required this.id,
    required this.projectName,
    required this.hrs,
    required this.breakTime,
    required this.taskType,
    this.taskName,
    this.otherTaskName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectName': projectName,
      'hrs': hrs,
      'breakTime': breakTime,
      'taskType': taskType,
      'taskName': taskName,
      'otherTaskName': otherTaskName,
    };
  }

  factory TimeSheetModel.fromMap(Map<String, dynamic> map) {
    return TimeSheetModel(
      id: map['id'] as int,
      projectName: map['project_name'] as String,
      hrs: map['hrs'] as String,
      breakTime: map['break_time'] as String,
      taskType: map['task_type'] as int,
      taskName: map['task_name'] as String?,
      otherTaskName: map['other_task_name'] as String?,
    );
  }
}