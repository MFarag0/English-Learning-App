import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kalimati_app/features/auth/presentation/providers/teacher_package_notifier.dart';
import 'package:kalimati_app/features/home/presentation/providers/package_notifier.dart';
import 'package:kalimati_app/features/games/flashcards/presentation/providers/flashcard_notifier.dart';
import 'package:kalimati_app/features/home/domain/entities/definition.dart';
import 'package:kalimati_app/features/home/domain/entities/learning_package.dart';
import 'package:kalimati_app/features/home/domain/entities/resource.dart';
import 'package:kalimati_app/features/home/domain/entities/resource_type_enum.dart';
import 'package:kalimati_app/features/home/domain/entities/sentence.dart';
import 'package:kalimati_app/features/home/domain/entities/word.dart';



class AddPackageScreen extends ConsumerStatefulWidget {
  final String userId;
  
  const AddPackageScreen({super.key, required this.userId});

  @override
  ConsumerState<AddPackageScreen> createState() => _AddPackageScreenState();
}

  class _AddPackageScreenState extends ConsumerState<AddPackageScreen> {
    List<Definition> definitions = [];
    List<Sentence> sentences = [];
    List<Word> words = [];
    final _wordController = TextEditingController();
    var definitionController = TextEditingController();
    var definitionSourceController = TextEditingController();

    
    var sentenceController = TextEditingController();
    var sentenceTitleController = TextEditingController();
    var sentenceUrlController = TextEditingController();

    String type = "Photo";
    final _titleController = TextEditingController();
    final _categoryController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _iconUrlController = TextEditingController();
    
    
    var date = DateTime.now().toIso8601String().split("T")[0];
    String _level = "Beginner";
    

  @override
  Widget build(BuildContext context) {
    
  
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 120, 165, 243),
          title: Text("Add Package", style: TextStyle(color: Colors.white,fontFamily: 'cursive', fontWeight:FontWeight.bold, fontSize: 30),),
        ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.blue, width: 2),
                            ),
                            ),
        
                        ),
                        SizedBox(height: 10,),
                        TextField(
                          controller: _categoryController,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.blue, width: 2),
                            ),
                            ),
                        ),
                        SizedBox(height: 10,),
                        TextField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.blue, width: 2),
                            ),
                            ),
                            
                        ),
                        SizedBox(height: 10,),
                        TextField(
                          controller: _iconUrlController,
                          decoration: InputDecoration(
                            labelText: 'Icon URL',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.blue, width: 2),
                            ),),
                        ),
                        SizedBox(height: 10,),
                        DropdownButtonFormField<String>(
                          value: _level,
                          items: ['Beginner', 'Intermediate', 'Advanced']
                              .map((level) => DropdownMenuItem(
                                    value: level,
                                    child: Text(level),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _level = value!;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Level',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.blue, width: 2),
                            ),
                          ),
                        ),
                      
                        
                        SizedBox(height: 20,),
                       
        
                      ],
                    ),
                  ),
                ),
              ),
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text("Add Words",style:TextStyle(fontFamily: 'serif', fontSize: 22, fontWeight: FontWeight.bold),),
                 SizedBox(width: 190,),
                 IconButton(
                  onPressed: () { 
                    showDialog(
                      context: context, 
                      builder: (context) => AlertDialog(
                        title: Text("Words Added"),
                        content: SizedBox(
                          width: 200,
                          height: 200,
                          child: Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: words.length,
                              itemBuilder: (context, index) {
                                
                                return ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        child: Text("- ${words[index].text}")),
                                      
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            words.removeAt(index);
                                            Navigator.of(context).pop();

                                          }); },
                                         
                                         icon: Icon(Icons.delete, color: Colors.red,))
                                    ],
                                  ),
                                  
                                );
                              },
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => context.pop(),
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.article))
               ],
             ),
             _buildWordsSection(),
             SizedBox(height: 7,),
             ElevatedButton(
              
              style: TextButton.styleFrom(
                elevation: 4,
                backgroundColor: const Color.fromARGB(255, 226, 140, 133),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
                  side: BorderSide(color: const Color.fromARGB(255, 173, 171, 171))
                ),
              onPressed: () async {
                if (_titleController.text.isEmpty || _categoryController.text.isEmpty || _descriptionController.text.isEmpty || _iconUrlController.text.isEmpty || words.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please fill in all the remaining fields!'),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ));
                        return;
                      }
                
                
                
                
                await ref.read(teacherPackageProvider.notifier).addPackage(
                  LearningPackage(
                    packageId: DateTime.now().millisecondsSinceEpoch.toString(),
                    author: widget.userId,
                    category: _categoryController.text,
                    description: _descriptionController.text,
                    iconUrl: _iconUrlController.text,
                    language: "English",
                    lastUpdatedDate: date,
                    level: _level,
                    title: _titleController.text,
                    version: 1,
                    words: words,
                  )
                );
                ref.invalidate(packageNotifierProvider);
                ref.invalidate(flashcardNotifierProvider);
                ref.read(packageRefreshProvider.notifier).state++;
        
  
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Package created successfully!'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  )
                
                );
                context.pop();

              },
              child: Text("Create Package", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)
             ),
              
             
          ],
          );  
        },
      )
    );
    


  }


Widget _buildWordsSection() {
  return Column(
    children: [
      Card(
        elevation: 4,
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(children: [
                Expanded(
                  child: TextField(
                    controller: _wordController,
                    decoration: InputDecoration(
                      labelText: 'Word Text',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  )
                ),
              ],),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                TextButton(
                  onPressed: () => _addDefinition(), 
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 120, 165, 243),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                      side: BorderSide(color: const Color.fromARGB(255, 173, 171, 171))
                    ),
                  child: Text("Add Definition", style: TextStyle(color: Colors.white),),
                  ),
                SizedBox(width: 20,),
                TextButton(
                  onPressed: () => _addSentences(),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 120, 165, 243),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                      side: BorderSide(color: const Color.fromARGB(255, 173, 171, 171))
                    ),
                  child: Text("Add Sentence", style: TextStyle(color: Colors.white),)
                  ),
                  SizedBox(width: 20,),
              ],),
             
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      if (_wordController.text.isEmpty || definitions.isEmpty || sentences.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please fill in all fields when adding definitions and sentences!'),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ));
                        return;
                      }
                      Word word = Word(
                        text: _wordController.text,
                        definitions: definitions,
                        sentences: sentences,
                      );
                      setState(() {
                        words.add(word);
                        
                      });
                      _wordController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                        content: Text('Word added to the package!'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ));
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                        side: BorderSide(color: const Color.fromARGB(255, 173, 171, 171))
                      ),
                    child: Text("Add Word", style: TextStyle(color: Colors.white),))
                ],
              )
              

            ],
          ),
      )
      ),
    ],
  );
}
Future _addDefinition() {

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Add Definition"),
      content: SizedBox(
        width: 300,
        height: 150,
        child: Column(
          children: [
            TextField(
              controller: definitionController,
              decoration: InputDecoration(
                hintText: "Enter definition", 
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),),
            ),
            SizedBox(height: 30),
            TextField(
              controller: definitionSourceController,
              decoration: InputDecoration(
                hintText: "Source",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
                ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
            },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (definitionController.text.isEmpty || definitionSourceController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please fill in the remaining fields!'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }
            
            Definition definition = Definition(text: definitionController.text, source: definitionSourceController.text);
            setState(() {
            definitions.add(definition);
            definitionController.clear();
            definitionSourceController.clear();
            context.pop();
            });
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Definition added!'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
           
            
          },
          child: Text("Add"),
        ),
      ],
    ),
  );
}
Future _addSentences() {

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Add Sentence"),
      content: SizedBox(
        width: 300,
        height: 310,
        child: Column(
          children: [
            TextField(
              controller: sentenceController,
              decoration: InputDecoration(
                hintText: "Enter sentence", 
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.start,children: [Text("Sources")],),
            SizedBox(height: 10,),
            TextField(
              controller: sentenceTitleController,
              decoration: InputDecoration(
                hintText: "Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
            ),),
            SizedBox(height: 10,),
            TextField(
              controller: sentenceUrlController,
              decoration: InputDecoration(
                hintText: "Url",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey, width: 2),

                ),
            ),),
            SizedBox(height: 10,),
                  DropdownButtonFormField<String>(
                  value: type,
                  items: ['Photo', 'Video', 'Website']
                    .map((level) => DropdownMenuItem(
                    value: level,
                    child: Text(level),
                  )).toList(),
                    onChanged: (value) {
                        setState(() {
                            type = value!;
                          });
                        },
                          decoration: InputDecoration(
                            labelText: 'Media Type',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.blue, width: 2),
                            ),
                          ),
                        ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            sentenceController.clear();
            sentenceTitleController.clear();
            sentenceUrlController.clear();
            context.pop();},
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            
            
            if (sentenceTitleController.text.isEmpty || sentenceUrlController.text.isEmpty || sentenceController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please fill in the required fields!'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }
            Sentence sentence = Sentence(text: sentenceController.text, resources: [Resource(title: sentenceTitleController.text, url: sentenceUrlController.text, type: type.toString() == "Photo" ? ResourceTypeEnum.photo : type.toString() == "Video" ? ResourceTypeEnum.video : ResourceTypeEnum.website)]);
            sentences.add(sentence);
            sentenceController.clear();
            sentenceTitleController.clear();
            sentenceUrlController.clear();
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Sentence added!'),
                duration: Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Text("Add"),
        ),
      ],
    ),
  );
}

  
  }