import '../bloc/app_state.dart';

class TemplateData extends DropDownData {
  TemplateData({required super.id, required super.name});

  factory TemplateData.fromMap(Map<String, dynamic> map) {
    return TemplateData(
      name: map['template_name'] as String,
      id: map['id'] as int,
    );
  }
}