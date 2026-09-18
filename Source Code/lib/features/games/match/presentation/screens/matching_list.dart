import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kalimati_app/features/home/presentation/providers/package_notifier.dart';

class MatchingList extends ConsumerStatefulWidget {
  const MatchingList({super.key});

  @override
  ConsumerState<MatchingList> createState() => _MatchingListState();
}

class _MatchingListState extends ConsumerState<MatchingList> {
  @override
  Widget build(BuildContext context) {
    final packages = ref.watch(packageNotifierProvider); 
    ref.read(packageNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => context.pop(),
          child: Icon(Icons.keyboard_arrow_left, color: Colors.white, size: 40),
        ),
        toolbarHeight: 80,
        backgroundColor: const Color.fromARGB(255, 120, 165, 243),
        title: Text(
          "Matching Words",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'cursive',
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 202, 222, 240),
        child: Container(
          color: const Color.fromARGB(255, 202, 222, 240),
          child: packages.when(
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stack) =>
                Center(child: Text("Error loading packages")),
            data: (packages) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: packages.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () =>
                        context.push('/match/${packages[index].packageId}'),
                    child: Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(15),
                        leading: ClipOval(
                          child: Image.network(
                            packages[index].iconUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                                size: 50,
                              );
                            },
                          ),
                        ),
                        title: Text(
                          packages[index].title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Level: ${packages[index].level}"),
                            SizedBox(height: 5),
                            Text(packages[index].description),
                          ],
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
