import 'package:kalimati_app/features/games/match/domain/entities/pairs.dart';
import 'package:kalimati_app/features/home/domain/entities/word.dart';

List<Pair> get_pairs(List<Word> words){
  return words.map((word)=>Pair(word: word.text, definition: word.definitions[0].text)).toList();
}