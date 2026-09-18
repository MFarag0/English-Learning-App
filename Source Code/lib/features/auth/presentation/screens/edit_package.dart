import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kalimati_app/features/auth/presentation/providers/teacher_package_notifier.dart';
import 'package:kalimati_app/features/home/domain/entities/definition.dart';
import 'package:kalimati_app/features/home/domain/entities/resource.dart';
import 'package:kalimati_app/features/home/domain/entities/resource_type_enum.dart';
import 'package:kalimati_app/features/home/domain/entities/sentence.dart';
import 'package:kalimati_app/features/home/presentation/providers/package_notifier.dart';
import 'package:kalimati_app/features/games/flashcards/presentation/providers/flashcard_notifier.dart';
import 'package:kalimati_app/features/home/domain/entities/learning_package.dart';
import 'package:kalimati_app/features/home/domain/entities/word.dart';

class EditPackage extends ConsumerStatefulWidget {
  final String packageId;
  const EditPackage({super.key, required this.packageId});

  @override
  ConsumerState<EditPackage> createState() => _EditPackageState();
}

class _EditPackageState extends ConsumerState<EditPackage> {
  
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _titleController = TextEditingController();
  final _iconurlController = TextEditingController();
  
  String _level = "Beginner";
  var updatedDate = DateTime.now().toIso8601String().split("T")[0];
  bool _isInitialized = false;
  List<Word> words = [];
  
  
  final _wordController = TextEditingController();
  var definitionController = TextEditingController();
  var definitionSourceController = TextEditingController();
  var sentenceController = TextEditingController();
  var sentenceTitleController = TextEditingController();
  var sentenceUrlController = TextEditingController();
  String type = "Photo";
  List<Definition> newWordDefinitions = [];
  List<Sentence> newWordSentences = [];


  @override
  Widget build(BuildContext context) {
    final packages = ref.watch(teacherPackageProvider);
    return packages.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Center(child: Text("Error loading package")),
      data: (data) {
      final currentPak = data.firstWhere((p) => p.packageId == widget.packageId);
      
      
      if (!_isInitialized) {
        _level = currentPak.level;
        _isInitialized = true;
        _titleController.text = currentPak.title;
        _categoryController.text = currentPak.category;
        _descriptionController.text = currentPak.description;
        _iconurlController.text = currentPak.iconUrl;
        words = currentPak.words;

      }
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 120, 165, 243),
          title: Text("Edit Package", style: TextStyle(color: Colors.white,fontFamily: 'cursive', fontWeight:FontWeight.bold, fontSize: 30),),
          actions: [
            IconButton(
              icon: Icon(Icons.save, color: Colors.white),
              onPressed: () async{
                await ref.read(teacherPackageProvider.notifier).updatePackage(
                  LearningPackage(
                    packageId: currentPak.packageId,
                    author: currentPak.author,
                    language: "English",
                    words: words,
                    title: _titleController.text,
                    category: _categoryController.text,
                    description: _descriptionController.text,
                    iconUrl: _iconurlController.text,
                    level: _level,
                    version: currentPak.version + 1,
                    lastUpdatedDate: updatedDate,
                  )
                );
                ref.invalidate(packageNotifierProvider);
                ref.invalidate(flashcardNotifierProvider);
                ref.read(packageRefreshProvider.notifier).state++;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Package Updated Successfully!', style: TextStyle(color: Colors.white),),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                context.pop();
              },
            ),
          ],
        ),
        body: Column(
          
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
                          controller: _iconurlController,
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
                        Text("Version: ${currentPak.version}", textAlign: TextAlign.start,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                       
        
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Text("Last Updated: ${currentPak.lastUpdatedDate}", style: TextStyle(fontSize: 15, color: const Color.fromARGB(255, 151, 148, 148)),),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Words in Package", style: TextStyle(fontFamily: 'serif',fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(width: 70,),
                TextButton(
                  onPressed: () {
                    _showAddWordDialog();
                  },
                  child: Icon(Icons.add_circle, size: 30,color: const Color.fromARGB(255, 120, 165, 243),),
                ),  
              ],
            ),
            SizedBox(height: 10,),
            Expanded(
              child: ListView.builder(
                itemCount: words.length,
                itemBuilder: (context,index){
                  final word = words[index];
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      child: ListTile(
                        title: Column(
                          children: [
                            Text(word.text,textAlign: TextAlign.center, style: TextStyle(fontFamily: 'serif',fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 15,)
                          ],
                        ),
                        
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 120, 165, 243),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                                  side: BorderSide(color: const Color.fromARGB(255, 173, 171, 171))
                                ),
                              onPressed: (){
                                _editDefinitions(word);
                              },
                              child: Text("Edit Definitions", style: TextStyle(color: Colors.white),)
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 120, 165, 243),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                                side: BorderSide(color: const Color.fromARGB(255, 173, 171, 171))
                              ),
                              onPressed: () {
                                _editSentences(word);
                              }, 
                              child: Text("Edit Sentences", style: TextStyle(color: Colors.white),),
                            ),
                            IconButton(
                            onPressed: (){
                              showDialog(
                                       context: context, 
                                       builder: (context) => AlertDialog(
                                         title: Text("Delete Word", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                         content: Text("Are you sure you want to delete this word?", style: TextStyle(color: const Color.fromARGB(255, 108, 108, 108))),
                                         actions: [
                                           TextButton(
                                             onPressed: (){
                                               setState(() {
                                               words.remove(word);
                                             });
                                             context.pop();
                                             },
                                               style: TextButton.styleFrom(
                                                 backgroundColor: Colors.red,
                                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                             ),
                                                child: Text("Yes", style: TextStyle(color: Colors.white),),
                                           ),
                                          TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.transparent,
                                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                              ),
                                               onPressed: () {
                                              context.pop();
                                                
                                               },
                                             child: Text("No", style: TextStyle(color: const Color.fromARGB(255, 110, 109, 109)),),
                                             )
                                         ],
                                       ),
                               );
                              },
                              icon: Icon(Icons.delete, color: Colors.red,),
                            ),
                          ],
                        ),
                        
                              
                      ),
                    ),
                  );
                          }, 
                        

                       
                    ),
                  ),
        ],),
      );
                
      }
    );
  } 

  
  void _showAddWordDialog() {
    
    _wordController.clear();
    newWordDefinitions.clear();
    newWordSentences.clear();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New Word", style: TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 400,
            height: 180,
            child: Column(
              children: [
                TextField(
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
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => _addDefinitionForNewWord(), 
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 120, 165, 243),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                          side: BorderSide(color: const Color.fromARGB(255, 173, 171, 171))
                        ),
                      child: Text("Add Definition", style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(width: 20),
                    TextButton(
                      onPressed: () => _addSentenceForNewWord(),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 120, 165, 243),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                          side: BorderSide(color: const Color.fromARGB(255, 173, 171, 171))
                        ),
                      child: Text("Add Sentence", style: TextStyle(color: Colors.white))
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _wordController.clear();
                newWordDefinitions.clear();
                newWordSentences.clear();
                context.pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (_wordController.text.isEmpty || newWordDefinitions.isEmpty || newWordSentences.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please fill in all fields when adding definitions and sentences!'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ));
                  return;
                }
                Word newWord = Word(
                  text: _wordController.text,
                  definitions: newWordDefinitions,
                  sentences: newWordSentences,
                );
      
                setState(() {
                  words.add(newWord);
                });
                _wordController.clear();
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Word added to the package!'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  )
                );
              },
              child: Text("Add Word"),
            ),
          ],
        ),
    );
  }

  Future _addDefinitionForNewWord() {
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
                  ),
                ),
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
                newWordDefinitions.add(definition);
                definitionController.clear();
                definitionSourceController.clear();
                context.pop();
              });
               ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Definition Added!'),
                    duration: Duration(seconds: 2),
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

  Future _addSentenceForNewWord() {
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
              SizedBox(height: 10),
              TextField(
                controller: sentenceTitleController,
                decoration: InputDecoration(
                  hintText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: sentenceUrlController,
                decoration: InputDecoration(
                  hintText: "Url",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 10),
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
              context.pop();
            },
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
              setState(() {
                newWordSentences.add(sentence);
                sentenceController.clear();
                sentenceTitleController.clear();
                sentenceUrlController.clear();
                context.pop();
              });
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

Future _editDefinitions(word){
  final _definitionController = TextEditingController();
  final _definitionSourceController = TextEditingController();
 return showDialog(
  
      context: context, 
      builder: (context){
        return AlertDialog(
          title: Row(
            children: [
              Text("Edit Definitions"),
              SizedBox(width: 70,),
              IconButton(
                onPressed: (){
                  showDialog(

                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Add Definition"),
                  content: SizedBox(
                    width: 300,
                    height: 150,
                    child: Column(
                      children: [
                        TextField(
                          controller: _definitionController,
                          decoration: InputDecoration(
                            hintText: "Enter definition", 
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey, width: 2),
                            ),),
                        ),
                        SizedBox(height: 30),
                        TextField(
                          controller: _definitionSourceController,
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
                        Definition definition = Definition(
                          text: _definitionController.text, 
                          source: _definitionSourceController.text,);
                        setState(() {
                          word.definitions.add(definition);
                          _definitionController.clear();
                          _definitionSourceController.clear();
                        context.pop();
                        });
                      
                        
                      },
                      child: Text("Add"),
                    ),
                  ],
                ),
              );
                }, 
                icon: Icon(Icons.add_circle),
              ),
            ],
          ),
          
          actions: [
            Expanded(
              child: SizedBox(
                width: 350,
                height: 500,
                child: ListView.builder(
                  itemCount: word.definitions.length,
                  itemBuilder: (context, index){
                    final definitionController = TextEditingController(text: word.definitions[index].text);
                    final definitionSourceController = TextEditingController(text: word.definitions[index].source);
                    
                    return Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Definition ${index + 1}',
                            border: OutlineInputBorder(),
                          ),
                          controller: definitionController,
                        ),
                        SizedBox(height: 10,),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Source',
                            border: OutlineInputBorder(),
                          ),
                          controller: definitionSourceController,
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 120, 165, 243),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                                side: BorderSide(color: const Color.fromARGB(255, 173, 171, 171))
                              ),
                              onPressed: () {
                                Definition updatedDef = Definition(
                                  text: definitionController.text,
                                  source: definitionSourceController.text,
                                );
                                setState(() {
                                  words[words.indexOf(word)].definitions[index] = updatedDef;
                                  SnackBar snackBar = SnackBar(
                                    content: Text("Definition Updated", style: TextStyle(color: Colors.white),),
                                    duration: Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  
                                });
                               
                              }, 
                              child: Text("Save Definition", style: TextStyle(color: Colors.white),)
                              ),
                            
                             TextButton(
                              style: TextButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                                side: BorderSide(color: const Color.fromARGB(255, 173, 171, 171))
                              ),
                              onPressed: () {
          
                                setState(() {
                                  showDialog(
                                       context: context, 
                                       builder: (context) => AlertDialog(
                                         title: Text("Delete Definition", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                         content: Text("Are you sure you want to delete this definition?", style: TextStyle(color: const Color.fromARGB(255, 108, 108, 108))),
                                         actions: [
                                           TextButton(
                                             onPressed: (){
                                               setState(() {
                                                words[words.indexOf(word)].definitions.removeAt(index);
                                                context.pop();
                                             });
                                             
                                             },
                                               style: TextButton.styleFrom(
                                                 backgroundColor: Colors.red,
                                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                             ),
                                                child: Text("Yes", style: TextStyle(color: Colors.white),),
                                           ),
                                            TextButton(
                                                style: TextButton.styleFrom(
                                                backgroundColor: Colors.transparent,
                                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                              ),
                                               onPressed: () {
                                                context.pop();
                                                
                                               },
                                             child: Text("No", style: TextStyle(color: const Color.fromARGB(255, 110, 109, 109)),),
                                             )
                                         ],
                                       ),
                               );
                                });
                                

                              }, 
                              child: Text("Delete Definition", style: TextStyle(color: Colors.white),))
                          ],
                        ),
                        Divider(),
                        SizedBox(height: 10,),
                        
                      ],
                    );
                  }
                  ),
              ),
            ),
            TextButton(
                onPressed: (){
                  context.pop();
                }, 
                child: Text("Close"),
            )
          ],
        ); 
      }
    );
}

Future _editSentences(word){
  return showDialog(
    context: context, 
    builder: (context){
      return AlertDialog(
        title: Row(
          children: [
            Text("Edit Sentences"),
            SizedBox(width: 70,),
            IconButton(
              onPressed: (){
                final sentenceController = TextEditingController();
                final sentenceTitleController = TextEditingController();
                final sentenceUrlController = TextEditingController();
                  var type = 'Photo';
                showDialog(
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
            
            if (sentenceController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please enter a sentence!'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }
            if (sentenceTitleController.text.isEmpty || sentenceUrlController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please fill in resource title and URL!'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }
            Sentence sentence = Sentence(text: sentenceController.text, resources: [Resource(title: sentenceTitleController.text, url: sentenceUrlController.text, type: type.toString() == "Photo" ? ResourceTypeEnum.photo : type.toString() == "Video" ? ResourceTypeEnum.video : ResourceTypeEnum.website)]);
            setState(() {
              word.sentences.add(sentence);
            });
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
              }, 
              icon: Icon(Icons.add_circle),
            ),
          ],
        ),
        content: SizedBox(
          width: 350,
          height: 500,
          child: ListView.builder(
            itemCount: word.sentences.length,
            itemBuilder: (context, index){
              final _sentenceController = TextEditingController(text: word.sentences[index].text);
              final _sentenceTitleController = TextEditingController(text: word.sentences[index].resources[0].title);
              final _sentenceUrlController = TextEditingController(text: word.sentences[index].resources[0].url);
              var type = word.sentences[index].resources[0].type.toString().split('.').last;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Sentence ${index + 1}',
                      border: OutlineInputBorder(),
                    ),
                    controller: _sentenceController,
                  ),
                  SizedBox(height: 20,),
                  Text("Sources"),
                  SizedBox(height: 20,),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    controller: _sentenceTitleController,
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Url',
                      border: OutlineInputBorder(),
                    ),
                    controller: _sentenceUrlController,
                  ),
                  SizedBox(height: 10,),
                  DropdownButtonFormField<String>(
                    initialValue: type,
                    items: ['photo', 'video', 'website']
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
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 120, 165, 243),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                          side: BorderSide(color: const Color.fromARGB(255, 173, 171, 171))
                        ),
                        onPressed: () {
                          Sentence updatedSentence = Sentence(
                            text: _sentenceController.text,
                            resources: [
                              Resource(
                                title: _sentenceTitleController.text, 
                                url: _sentenceUrlController.text, 
                                type: type == "photo" ? ResourceTypeEnum.photo : 
                                      type == "video" ? ResourceTypeEnum.video : 
                                      ResourceTypeEnum.website
                              )
                            ]
                          );
                          setState(() {
                            words[words.indexOf(word)].sentences[index] = updatedSentence;
                            SnackBar snackBar = SnackBar(
                              content: Text("Sentence Updated", style: TextStyle(color: Colors.white),),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          });
                        }, 
                        child: Text("Save Sentence", style: TextStyle(color: Colors.white),)
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                          side: BorderSide(color: const Color.fromARGB(255, 173, 171, 171))
                        ),
                        onPressed: () {
                          setState(() {
                            showDialog(
                              context: context, 
                              builder: (context) => AlertDialog(
                                title: Text("Delete Sentence", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                content: Text("Are you sure you want to delete this sentence?", style: TextStyle(color: const Color.fromARGB(255, 108, 108, 108))),
                                actions: [
                                  TextButton(
                                    onPressed: (){
                                      setState(() {
                                        words[words.indexOf(word)].sentences.removeAt(index);
                                        context.pop();
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    ),
                                    child: Text("Yes", style: TextStyle(color: Colors.white),),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    ),
                                    onPressed: () {
                                      context.pop();
                                    },
                                    child: Text("No", style: TextStyle(color: const Color.fromARGB(255, 110, 109, 109)),),
                                  )
                                ],
                              ),
                            );
                          });
                        }, 
                        child: Text("Delete Sentence", style: TextStyle(color: Colors.white),)
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 10,),
                ],
              );
            }
          ),
        ),
        actions: [
          TextButton(
            onPressed: (){
              context.pop();
            }, 
            child: Text("Close"),
          ),
        ],
      ); 
    }
  );
}
}


