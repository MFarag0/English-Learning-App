//definitions": [
//           {
//             "text": "Place to go shopping",
//             "source": "Wikipedia"
//           }
//         ],
//         "sentences": [
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

class Definition {
  final String text;
  final String source;

  Definition({required this.text, required this.source});

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(text: json['text'] as String, source: json['source']);
  }

  Map<String, dynamic> toJson() {
    return {"text": text, "source": source};
  }
}
