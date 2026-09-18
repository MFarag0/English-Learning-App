//[{
//         "text": "Mall",
//         "definitions": [
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
//           }
//         ]
//       },
//       {
//         "text": "School",
//         "definitions": [
//           {
//             "text": "Place to learn",
//             "source": "Wikipedia"
//           },
//           {
//             "text": "Place where kids receive their education",
//             "source": "Wikipedia"
//           }
//         ],
//         "sentences": [
//           {
//             "text": "My son goes to Doha British School",
//             "resources": [
//               {
//                 "title": "Doha British School",
//                 "url": "https://www.dohabritishschool.com/dbs-ainkhaled/public/uploads/pages/1568797241.jpg",
//                 "type": "Photo"
//               },
//               {
//                 "title": "Learn and have fun",
//                 "url": "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",
//                 "type": "Video"
//               }
//             ]
//           }
//         ]
//       },
//       {
//         "text": "Park",
//         "definitions": [
//           {
//             "text": "Place to play and have fun",
//             "source": "Wikipedia"
//           },
//           {
//             "text": "Small natural areas in the middle of the town",
//             "source": "Wikipedia"
//           }
//         ],
//         "sentences": [
//           {
//             "text": "We are playing at the park",
//             "resources": [
//               {
//                 "title": "Aspire Park",
//                 "url": "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e2/Aspire_Park%2C_Doha_-_panoramio_%281%29.jpg/440px-Aspire_Park%2C_Doha_-_panoramio_%281%29.jpg",
//                 "type": "Photo"
//               },
//               {
//                 "title": "Al Khor Family Park",
//                 "url": "https://www.iloveqatar.net/public/images/local/_760x500_clip_center-center_none/EQprMssWsAA9FWx.jpg",
//                 "type": "Photo"
//               }
//             ]
//           }
//         ]
//       },
//       {
//         "text": "Hospital",
//         "definitions": [
//           {
//             "text": "Place where sick people go to get cured",
//             "source": "Wikipedia"
//           },
//           {
//             "text": "Place where doctors treat patients",
//             "source": "Wikipedia"
//           }
//         ],
//         "sentences": [
//           {
//             "text": "I am sick, so I will go to the hospital",
//             "resources": [
//               {
//                 "title": "Hamad Hospital",
//                 "url": "https://thepeninsulaqatar.com/uploads/2017/06/20/post_main_cover_fit//9cecf42be0f4dcfa2b6f7e0d78e2ac8cb3b91c7c.jpg",
//                 "type": "Photo"
//               },
//               {
//                 "title": "Sidra Medical and Research Center",
//                 "url": "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9b/Construction_of_Sidra_Medical_and_Research_Center_in_2014.jpg/440px-Construction_of_Sidra_Medical_and_Research_Center_in_2014.jpg",
//                 "type": "Photo"
//               },
//               {
//                 "title": "Sidra Medical and Research Center Tour",
//                 "url": "https://erradi.github.io/Sidra-Medicine.mp4",
//                 "type": "Video"
//               }
//             ]
//           }
//         ]
//       },
//       {
//         "text": "Coffee shop",
//         "definitions": [
//           {
//             "text": "Place to buy coffee and small meals",
//             "source": "Wikipedia"
//           }
//         ],
//         "sentences": [
//           {
//             "text": "I want to buy a coffee from the coffee shop",
//             "resources": [
//               {
//                 "title": "Starbucks Coffee",
//                 "url": "https://ezdanmall.qa/al-gharaffa/wp-content/uploads/sites/2/2018/08/STARBUCKS-COFFEE.jpg",
//                 "type": "Photo"
//               },
//               {
//                 "title": "Delicious Coffee",
//                 "url": "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",
//                 "type": "Video"
//               }
//             ]
//           }
//         ]
//       },
//       {
//         "text": "Dentist",
//         "definitions": [
//           {
//             "text": "Place to go to cure pain in your teeth",
//             "source": "Wikipedia"
//           }
//         ],
//         "sentences": [
//           {
//             "text": "I will go to the dentist because I have a toothache",
//             "resources": [
//               {
//                 "title": "Dentist",
//                 "url": "https://www.qu.edu.qa/static_file/qu/colleges/dentistry/showarea/10.jpg",
//                 "type": "Photo"
//               }
//             ]
//           }
//         ]
//       },
//       {
//         "text": "University",
//         "definitions": [
//           {
//             "text": "Place to get higher education",
//             "source": "Wikipedia"
//           }
//         ],
//         "sentences": [
//           {
//             "text": "I will study Medicine at Qatar university",
//             "resources": [
//               {
//                 "title": "Qatar university",
//                 "url": "https://www.qu.edu.qa/static_file/qu/research/images/about%208.jpg",
//                 "type": "Photo"
//               },
//               {
//                 "title": "Qatar University Website",
//                 "url": "https://www.qu.edu.qa/",
//                 "type": "Website"
//               }
//             ]
//           }
//         ]
//       }
//     ]

import 'package:kalimati_app/features/home/domain/entities/definition.dart';
import 'package:kalimati_app/features/home/domain/entities/sentence.dart';

class Word {
  final String text;
  final List<Definition> definitions;
  final List<Sentence> sentences;

  Word({
    required this.text,
    required this.definitions,
    required this.sentences,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      text: json['text'] as String,
      definitions: (json['definitions'] as List<dynamic>)
          .map((defMap) => Definition.fromJson(defMap))
          .toList(),
      sentences: (json['sentences'] as List<dynamic>)
          .map((senMap) => Sentence.fromJson(senMap))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'definitions': definitions
          .map((definition) => definition.toJson())
          .toList(),
      'sentences': sentences.map((sentence) => sentence.toJson()).toList(),
    };
  }
}
