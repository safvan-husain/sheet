import 'package:new_app/bloc/app_state.dart';

class ProjectData extends DropDownData{
  String? projectNumber;
  String? location;
  String? latitude;
  String? longitude;

  ProjectData(
      {required super.id,
        required super.name,
        this.projectNumber,
        this.location,
        this.latitude,
        this.longitude});

factory  ProjectData.fromJson(Map<String, dynamic> json) {
  return ProjectData(
    id : json['id'],
    name : json['name'],
    projectNumber : json['project_number'],
    location : json['location'],
    latitude : json['latitude'],
    longitude : json['longitude'],
  );
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['id'] = id;
  //   data['name'] = name;
  //   data['project_number'] = projectNumber;
  //   data['location'] = location;
  //   data['latitude'] = latitude;
  //   data['longitude'] = longitude;
  //   return data;
  // }
}