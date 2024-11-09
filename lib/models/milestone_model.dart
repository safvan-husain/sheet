import 'package:new_app/bloc/app_state.dart';

class MilestoneData extends DropDownData {
  int? statusNumber;

  MilestoneData({required super.id,required super.name, this.statusNumber});

  factory MilestoneData.fromJson(Map<String, dynamic> json) {
    return MilestoneData(
    id : json['id'],
    name : json['name'],
    statusNumber : json['status_number'],
    );
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['name'] = this.name;
  //   data['status_number'] = this.statusNumber;
  //   return data;
  // }
}