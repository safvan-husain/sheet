import 'package:new_app/bloc/app_state.dart';

class TowerData extends DropDownData {

  TowerData({required super.id, required super.name});

factory  TowerData.fromJson(Map<String, dynamic> json) {
  return TowerData(
    id : json['id'],
    name : json['name'],
  );
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['name'] = this.name;
  //   return data;
  // }
}