// usecases/validate_unscramble.dart
import 'package:kalimati_app/features/games/unscramble/domain/entities/unscrambled_sentance.dart';

/// Normalize words (trim/lowercase) before comparison.
String _norm(String w) => w.trim().toLowerCase();

/// Validate the USER ATTEMPT against the original sentence.
/// (We DON'T compare to scrambledSentance.)
bool validateAttempt(UnscrambledSentance s, List<String> attempt) {
  if (attempt.length != s.originalSentance.length) return false;
  for (int i = 0; i < s.originalSentance.length; i++) {
    if (_norm(s.originalSentance[i]) != _norm(attempt[i])) return false;
  }
  return true;
}
