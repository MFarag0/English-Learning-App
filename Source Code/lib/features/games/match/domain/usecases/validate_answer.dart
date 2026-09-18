import 'package:kalimati_app/features/games/match/domain/entities/pairs.dart';

bool validateChoice(Pair p,String choice){
  if(p.definition.contains(choice)){
    return true;
  }
  return false;
}