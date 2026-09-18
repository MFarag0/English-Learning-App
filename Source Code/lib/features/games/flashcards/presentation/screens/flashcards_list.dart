import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kalimati_app/features/home/presentation/providers/package_notifier.dart';

class FlashcardsList extends ConsumerStatefulWidget {
  const FlashcardsList({super.key});

  @override
  ConsumerState<FlashcardsList> createState() => _FlashcardsListState();
}

class _FlashcardsListState extends ConsumerState<FlashcardsList> {
  @override
  Widget build(BuildContext context) {
    final packagesAsync = ref.watch(packageNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => context.pop(),
          child: const Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
            size: 40,
          ),
        ),
        toolbarHeight: 80,
        backgroundColor: const Color.fromARGB(255, 120, 165, 243),
        title: const Text(
          "Flashcards",
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
        child: packagesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) =>
              const Center(child: Text("Error loading packages")),
          data: (packages) => ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final p = packages[index];
              return InkWell(
                onTap: () => context.push('/flashcards/${p.packageId}'),
                child: Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    leading: ClipOval(
                      child: Image.network(
                        p.iconUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 50,
                          );
                        },
                      ),
                    ),
                    title: Text(
                      p.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Level: ${p.level}"),
                        const SizedBox(height: 5),
                        Text(p.description),
                      ],
                    ),
                    trailing: const Icon(
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
    );
  }
}
