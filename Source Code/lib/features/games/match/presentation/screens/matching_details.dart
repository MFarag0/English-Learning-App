import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kalimati_app/features/games/flashcards/presentation/providers/flashcard_notifier.dart';
import 'package:kalimati_app/features/games/match/domain/usecases/get_definition.dart';
import 'package:kalimati_app/features/games/match/domain/usecases/get_pairs.dart';
import 'package:kalimati_app/features/games/match/domain/usecases/validate_answer.dart';

class Matching extends ConsumerStatefulWidget {
  final String packageId;
  const Matching({super.key, required this.packageId});

  @override
  ConsumerState<Matching> createState() => _MatchingState();
}

class _MatchingState extends ConsumerState<Matching> {
    
 String _selectedWord = '';
 String _selectedDefinition = '';
 bool isMatched = false;
 bool matchedWord = false;
 bool isSelected = false;
 Set<String> _correctlyMatchedWords = {};
 List<String> _definitionsList = [];

  @override
  Widget build(BuildContext context) {
    final packages = ref.watch(flashcardNotifierProvider);

    return packages.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
      data: (packages) {
        final package = packages.firstWhere((p) => p.packageId == widget.packageId);
        final playableWords = package.words.where((w) => w.definitions.isNotEmpty).toList();
        final pairs = get_pairs(playableWords);
        if (_definitionsList.isEmpty && _correctlyMatchedWords.isEmpty) {
          _definitionsList = get_definitions(playableWords);
          _definitionsList.shuffle();
        }
        



        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            backgroundColor: const Color.fromARGB(255, 120, 165, 243),
            title: Text(package.title, style: TextStyle(color: Colors.white,fontFamily: 'cursive', fontWeight: FontWeight.bold, fontSize: 30
              ),
            ),
            leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.white, size: 40),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Match Words with Definitions',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 120, 165, 243),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text("Score: ${_correctlyMatchedWords.length} / ${playableWords.length}", style: TextStyle(fontSize: 16, fontFamily: 'serif'),),
                            SizedBox(height: 10),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromARGB(255, 224, 228, 231),
                                    ),
                                    child:SizedBox(
                                      width: 180,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: playableWords.length,
                                            
                                              itemBuilder: (context, index) => Padding(
                                                padding: const EdgeInsets.all(2),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    if (!_correctlyMatchedWords.contains(pairs[index].word)) {
                                                      setState(() {
                                                        if (_selectedWord == pairs[index].word) {
                                                          _selectedWord = '';
                                                        } else {
                                                          _selectedWord = pairs[index].word;
                                                        }
                                                        matchedWord = false;
                                                      });
                                                    }
                                                  },
                                                  child: Card(
                                                    elevation: 2,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                      child: Container(
                                                      
                                                      constraints: BoxConstraints(minHeight: 80),
                                                      width: double.infinity,
                                                      padding: EdgeInsets.all(10),
                                                      child: Row(
                                                        children: [
                                                          
                                                          _correctlyMatchedWords.contains(pairs[index].word) ? Icon(Icons.radio_button_checked, color: Colors.green,) : _selectedWord == pairs[index].word ? Icon(Icons.radio_button_checked, color: Colors.amber,) : Icon(Icons.radio_button_unchecked, color: Colors.grey,),
                                                          SizedBox(width: 8),
                                                          Flexible(child: Text(pairs[index].word, textAlign: TextAlign.center,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'serif'),)),
                                                        ],
                                                      ),
                                                       
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ),
                                          ),
                                          
                                        ],
                                                                            ),
                                    ),
                                      
                                    ),
                                    SizedBox(width: 5)
                                                       ,  
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(255, 224, 228, 231),
                                      ),
                                      child:SizedBox(
                                        width: 180,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                            child: ListView.builder(
                                              itemCount: _definitionsList.length,
                                            
                                              itemBuilder: (context, index) { 
                                              
                                              return Padding(
                                                padding: const EdgeInsets.all(2),
                                                child: GestureDetector(
                                                  onTap: (){
                                                    if (_selectedWord.isNotEmpty){
                                                    setState(() {
                                                      _selectedDefinition = _definitionsList[index];
                                                    });
                                                  final pair = pairs.firstWhere((pair) => pair.word == _selectedWord);
                                                  final matched = validateChoice(pair, _selectedDefinition);
                                                  if (matched){
                                        
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text('Correct Match!'),
                                                        backgroundColor: Colors.green,
                                                        behavior: SnackBarBehavior.floating,
                                                      ),
                                                    );
                                                     setState(() {
                                                      _correctlyMatchedWords.add(_selectedWord);
                                                      _selectedWord = '';
                                                      _selectedDefinition = '';
                                                      matchedWord = true;
                                                      _definitionsList.removeAt(index);
                                                     });
                                                  } else {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text('Incorrect Match. Try Again.'),
                                                        backgroundColor: Colors.red,
                                                        behavior: SnackBarBehavior.floating,
                                                      ),
                                                    );
                                                  }
                                                  }
                                                  },
                                                  child: Card(
                                                    elevation: 2,
                                                    
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                      child: Container(
                                                      
                                                      color: _selectedWord!='' ? const Color.fromARGB(255, 205, 222, 247) : Colors.white,
                                                      constraints: BoxConstraints(minHeight: 80),
                                                      width: double.infinity,
                                                      padding: EdgeInsets.all(10),
                                                      child: Text(_definitionsList[index], textAlign: TextAlign.center,style: TextStyle(fontSize: 16,fontFamily: 'serif')),
                                                    ),
                                                  ),
                                                ),
                                              );
                                              },
                                            ),
                                          ),
                                          ],
                                        ),
                                      )
                                      ),
                                  )
                                  
                                ],
                              ),
                            )     
                          
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                
                
                
                
              
                SizedBox(
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 100,
                      child: TextButton(
                        onPressed: (){
                          _selectedWord = '';
                          _selectedDefinition = '';
                          setState((){
                              isMatched = false;
                              matchedWord = false;
                              isSelected = false;
                              _correctlyMatchedWords.clear();
                              _definitionsList.clear();
                          });
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 235, 211, 140),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text("Reset", style: TextStyle(fontSize: 18, fontFamily: 'serif', color: Colors.white),)
                        ),
                    ),
                      SizedBox(
                        width: 100,
                        child: TextButton(
                        onPressed: () => context.pop(),
                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 120, 165, 243),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text("Exit", style: TextStyle(fontSize: 18, fontFamily: 'serif', color: Colors.white),)
                        ),
                      ),
                  ],
                ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
