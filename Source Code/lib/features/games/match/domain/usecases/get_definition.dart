import 'package:kalimati_app/features/home/domain/entities/word.dart';

List<String> get_definitions(List<Word> words) {
  return words.map((word) => word.definitions[0].text).toList();
}
