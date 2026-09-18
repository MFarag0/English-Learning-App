// {
//     "packageId": "p1",
//     "author": "a1@test.com",
//     "category": "Travel",
//     "description": "A list of 6 places that we can find in town",
//     "iconUrl": "https://cdn.icon-icons.com/icons2/1948/PNG/512/free-30-instagram-stories-icons02_122549.png",
//     "language": "English",
//     "lastUpdatedDate": "2023-09-17",
//     "level": "Beginner",
//     "title": "Places In Town",
//     "version": 2,
//     "words": [
//
//   }

import 'package:kalimati_app/features/home/domain/entities/word.dart';

class LearningPackage {
  final String packageId;
  final String author;
  final String category;
  final String description;
  final String iconUrl;
  final String language;
  final String lastUpdatedDate;
  final String level;
  final String title;
  final int version;
  final List<Word> words;

  // contructor
  LearningPackage({
    required this.packageId,
    required this.author,
    required this.category,
    required this.description,
    required this.iconUrl,
    required this.language,
    required this.lastUpdatedDate,
    required this.level,
    required this.title,
    required this.version,
    required this.words,
  });

  factory LearningPackage.fromJson(Map<String, dynamic> json) {
    return LearningPackage(
      packageId: json['packageId'] as String,
      author: json['author'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      iconUrl: json['iconUrl'] as String,
      language: json['language'] as String,
      lastUpdatedDate: json['lastUpdatedDate'] as String,
      level: json['level'] as String,
      title: json['title'] as String,
      version: json['version'] as int,
      words: (json["words"] as List<dynamic>)
          .map((wordMap) => Word.fromJson(wordMap))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'packageId': packageId,
      'author': author,
      'category': category,
      'description': description,
      'iconUrl': iconUrl,
      'language': language,
      'lastUpdatedDate': lastUpdatedDate,
      'level': level,
      'title': title,
      'version': version,
      'words': words.map((word) => word.toJson()).toList(),
    };
  }
}
