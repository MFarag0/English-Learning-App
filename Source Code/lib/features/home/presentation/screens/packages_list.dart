import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalimati_app/features/home/presentation/providers/package_notifier.dart';

class PackagesList extends ConsumerStatefulWidget {
  const PackagesList({super.key});

  @override
  ConsumerState<PackagesList> createState() => _PackagesListState();
}

class _PackagesListState extends ConsumerState<PackagesList> {
  @override
  Widget build(BuildContext context) {
    final packages = ref.watch(packageNotifierProvider);
    return Scaffold(
      body: Column(
        
        children: [
          
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) => ref.read(packageNotifierProvider.notifier).search(value),
                  
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Search by level or keyword...",
                    prefixIcon: Icon(Icons.search, color: Colors.blue),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 1, color: Colors.grey)
                      
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 2, color: Colors.blue)
                      
                    ),
                    
                  ),
                              
                              ),
                ),
              ),

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
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(15),
                            leading: 
                            ClipOval(
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
                            title: Text(packages[index].title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Level: ${packages[index].level}"),
                                  SizedBox(height: 5,),
                                  Text(packages[index].description),
                                ],
                              ),
                            trailing: IconButton(
                              onPressed: () => {
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Downloading "${packages[index].title}"...', style: TextStyle(color: Colors.white),),
                                    duration: Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                ),

                              },
                              icon: Icon(Icons.download), color: Colors.blue,),
                            
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