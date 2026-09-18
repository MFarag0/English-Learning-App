import 'package:kalimati_app/features/games/unscramble/domain/entities/unscrambled_sentance.dart';
import 'package:kalimati_app/features/home/domain/entities/sentence.dart';
import 'package:kalimati_app/features/home/domain/entities/word.dart';

List<UnscrambledSentance> getUnscrambledSentence(List<Word> words) {
  List<UnscrambledSentance> instances = [];
  List<List<Sentence>> get_sentences_lists = words
      .map((word) => word.sentences)
      .toList();
  List<Sentence> sentences = get_sentences_lists
      .expand((innerList) => innerList)
      .toList();

  instances = sentences
      .map(
        (sentence) => UnscrambledSentance(
          originalSentance: sentence.text.split(" "),
          scrambledSentance: List<String>.from(sentence.text.split(" "))
            ..shuffle(),
        ),
      )
      .toList();

  return instances;
}
