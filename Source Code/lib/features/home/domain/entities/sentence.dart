//"sentences": [
//           {
//             "text": "I bought a new bag from the mall",
//             "resources": [
//               {
//                 "title": "Mall of Qatar",
//                 "url": "https://gulfbusiness.com/wp-content/uploads/2016/12/Mall-of-Qatar.jpg",
//                 "type": "Photo"
//               },
//               {
//                 "title": "Mall of Qatar Tour",
//                 "url": "https://github.com/erradi/erradi.github.io/blob/master/Mall-of-Qatar-Tour.mp4?raw=true",
//                 "type": "Video"
//               }
//             ]

import 'package:kalimati_app/features/home/domain/entities/resource.dart';

class Sentence {
  final String text;
  final List<Resource> resources;

  Sentence({required this.text, required this.resources});

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      text: json['text'] as String,
      resources: (json['resources'] as List<dynamic>)
          .map((resourceMap) => Resource.fromJson(resourceMap))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "resources": resources.map((resource) => resource.toJson()).toList(),
    };
  }
}
