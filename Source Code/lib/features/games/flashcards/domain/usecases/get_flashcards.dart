import 'package:kalimati_app/features/games/flashcards/domain/entities/flashcard.dart';
import 'package:kalimati_app/features/home/domain/entities/resource.dart';
import 'package:kalimati_app/features/home/domain/entities/word.dart';

List<Flashcard> buildFlashcardsFromWords(List<Word> words) {
  List<Flashcard> flashcards = [];

  flashcards = words
      .map(
        (word) => Flashcard(
          title: word.text,
          media: word.sentences
              .expand((sen) => sen.resources)
              .whereType<Resource>() // I think this can be removed, not sure
              .toList(),
        ),
      )
      .toList();

  return flashcards;
}
