import 'package:new_app/bloc/app_state.dart';

class TaskData extends DropDownData {
  int? statusNumber;

  TaskData({required super.id, required super.name, this.statusNumber});

  factory TaskData.fromJson(Map<String, dynamic> json) {
    return TaskData(
      id: json['id'],
      name: json['name'],
      statusNumber: json['status_number'],
    );
    // super.id = json['id'];
    // .name = json['name'];
    // statusNumber = json['status_number'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['name'] = this.name;
  //   data['status_number'] = this.statusNumber;
  //   return data;
  // }
}
