import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kalimati_app/features/auth/presentation/providers/teacher_package_notifier.dart';
import 'package:kalimati_app/features/home/presentation/providers/package_notifier.dart';
import 'package:kalimati_app/features/games/flashcards/presentation/providers/flashcard_notifier.dart';

class TeacherPackages extends ConsumerStatefulWidget {
  final String userId;
  const TeacherPackages({super.key, required this.userId});

  @override
  ConsumerState<TeacherPackages> createState() => _TeacherPackagesState();
}

class _TeacherPackagesState extends ConsumerState<TeacherPackages> {

  @override
  Widget build(BuildContext context) {
    final packages = ref.watch(teacherPackageProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 120, 165, 243),
        title: Text("Kalimati", style: TextStyle(color: Colors.white,fontFamily: 'cursive', fontWeight:FontWeight.bold, fontSize: 30),),
        
        toolbarHeight: 80,
        actions: [
          IconButton(
            icon: Transform.translate(
              offset: Offset(0, 10),
              child: const Icon(Icons.logout, color: Colors.white)),
            onPressed: () {
              
              showDialog(
                context: context, 
                builder: (context) => AlertDialog(
                  title: Text("Logout", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  content: Text("Are you sure you want to logout?", style: TextStyle(color: const Color.fromARGB(255, 108, 108, 108))),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(
                        
                      ),
                      onPressed: () => Navigator.pop(context), 
                      child: Text("Cancel", style: TextStyle(color: const Color.fromARGB(255, 108, 108, 108)),)
                      ),
                    TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        onPressed: () => context.go('/home'),
                        child: Text("Logout", style: TextStyle(color: Colors.white),),
                      )
                    
                  ],
                )
          );},
          ),
        ],

      ),
      floatingActionButton: FloatingActionButton(
          onPressed: ()=>context.push('/addPackage/${widget.userId}'), 
          backgroundColor: const Color.fromARGB(255, 120, 165, 243),
          shape: CircleBorder(),
          child: Icon(Icons.add, color: Colors.white,size: 30,),
          ),
      
      body: Column(
        
        children: [
          
            

              Expanded(
                child: Container(
                  color: const Color.fromARGB(255, 202, 222, 240),
                  child: packages.when(
                    loading: () => Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(child: Text("Error loading packages")),
                    data: (packages) =>
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: packages.length,
                      itemBuilder: (context,index){
                        final package = packages[index];
                        return Card(
                          color: package.author == widget.userId ? Colors.white : Color.fromARGB(255, 231, 237, 243),
                          elevation: 3,
                          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(15),
                            leading: package.iconUrl.isNotEmpty? 
                            Container(
                              width: 50,
                              height: 50,
                              child: ClipOval(
                                child: Image.network(
                                  packages[index].iconUrl, 
                                  width: 50, 
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.image_not_supported, color: Colors.grey, size: 50);
                                  },
                                ),
                              ),
                            ) : Container(
                              width: 50,
                              height: 50,
                              child: Icon(Icons.add_box, color: Colors.blue, size: 50),
                            ),
                            title: Text(packages[index].title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Level: ${packages[index].level}"),
                                  SizedBox(height: 5,),
                                  Text(packages[index].description),
                                ],
                              ),
                            trailing: PopupMenuButton<String>(
                              elevation: 4,
                              borderRadius: BorderRadius.circular(20),
                              onSelected: (value) {
                                if (value == 'edit') {
                                  if (packages[index].author == widget.userId) {

                                    context.push('/editPackage/${package.packageId}');
                                  } else {
                                    
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        duration: Duration(seconds: 3),
                                        content: Text("You are not authorized to edit this package.")),
                                    );
                                  }
                                } else if (value == 'delete') {

                                  if (packages[index].author == widget.userId) {
                                    showDialog(
                                    context: context, 
                                    builder: (context) => AlertDialog(
                                      title: Text("Delete Package", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                      content: Text("Are you sure you want to delete this package?", style: TextStyle(color: const Color.fromARGB(255, 108, 108, 108))),
                                      actions: [
                                        TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            ),
                                            onPressed: () {
                                              ref.read(teacherPackageProvider.notifier).deletePackage(packages[index].packageId);
                                              ref.invalidate(packageNotifierProvider);
                                              ref.invalidate(flashcardNotifierProvider);
                                              ref.read(packageRefreshProvider.notifier).state++;
                                              context.pop();
                                            },
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
                                    )
                              );
                                   
                                  } else {
                                    
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("You are not authorized to delete this package.")),
                                    );
                                  }
                                }
                              },
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: "edit",
                                  child: Row(
                                    children: [
                                      Text('Edit'),
                                      SizedBox(width: 30),
                                      Icon(Icons.edit, color: Colors.blue)
                                    ],
                                  ),
                                ),
                                const PopupMenuItem<String>(
                                  value: "delete",
                                  child: Row(
                                    children: [
                                      Text('Delete'),
                                      SizedBox(width: 15),
                                      Icon(Icons.delete, color: Colors.red)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            
                          ),
                        );
                      },
                    ),
                  
                    ),
                  ),
                ),
              ),

 
        ],
      ),
    );
  }
}