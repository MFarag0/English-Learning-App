
import 'package:kalimati_app/features/home/domain/entities/resource.dart';

class Flashcard {
  final String title;          // word.text
  final List<Resource> media; // flattened media from all sentences
  Flashcard({required this.title, required this.media});
}
