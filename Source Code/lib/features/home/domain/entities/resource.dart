//"title": "Mall of Qatar",
//                 "url": "https://gulfbusiness.com/wp-content/uploads/2016/12/Mall-of-Qatar.jpg",
//                 "type": "Photo"

import 'package:kalimati_app/features/home/domain/entities/resource_type_enum.dart';

class Resource {
  final String title;
  final String url;
  final ResourceTypeEnum type;

  Resource({required this.title, required this.url, required this.type});

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      title: json['title'] as String,
      url: json['url'] as String,
      type: resourceTypeFromString(json['type']),
    );
  }
  Map<String, dynamic> toJson() {
    return {"title": title, "url": url, "type": type.name};
  }
}
