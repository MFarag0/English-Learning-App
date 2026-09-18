import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kalimati_app/features/games/flashcards/presentation/providers/flashcard_notifier.dart';
import 'package:kalimati_app/features/games/unscramble/domain/entities/unscrambled_sentance.dart';
import 'package:kalimati_app/features/games/unscramble/domain/usecases/get_unscrambled_sentence.dart';
import 'package:kalimati_app/features/games/unscramble/domain/usecases/validate.dart';

class Unscramble extends ConsumerStatefulWidget {
  final String packageId;
  const Unscramble({super.key, required this.packageId});

  @override
  ConsumerState<Unscramble> createState() => _UnscrambleState();
}

class _UnscrambleState extends ConsumerState<Unscramble> {
  final _pageController = PageController();
  int currentIndex = 0;
  List<List<String>> _attempts = [];
  late List<UnscrambledSentance> _scrambledSentences = [];

  @override
  Widget build(BuildContext context) {
    final packagesAsync = ref.watch(flashcardNotifierProvider);

    return packagesAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
      data: (packages) {
        final package = packages.firstWhere(
          (p) => p.packageId == widget.packageId,
        );

        final List<UnscrambledSentance> items = getUnscrambledSentence(
          package.words,
        );
        if (items.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('No sentences available')),
          );
        }
        _scrambledSentences = items;

        if (_attempts.length != items.length) {
          _attempts = List.generate(items.length, (index) => <String>[]);
        }

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            backgroundColor: const Color.fromARGB(255, 120, 165, 243),
            title: Text(
              package.title,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'cursive',
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            leading: InkWell(
              onTap: () => context.pop(),
              child: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _scrambledSentences.length,
                          onPageChanged: (index) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            final currentSentence = _scrambledSentences[index];
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    'Build the correct sentence:',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(
                                        255,
                                        120,
                                        165,
                                        243,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),

                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Your Sentence:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'serif',
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Wrap(
                                          spacing: 8,
                                          children: [
                                            ...List.generate(
                                              _attempts[index].length,
                                              (wordIndex) {
                                                return ChoiceChip(
                                                  label: Text(
                                                    _attempts[index][wordIndex],
                                                  ),
                                                  selected: true,
                                                  onSelected: (selected) {
                                                    setState(() {
                                                      _attempts[index].removeAt(
                                                        wordIndex,
                                                      );
                                                    });
                                                  },
                                                  selectedColor: Colors.blue,
                                                  showCheckmark: false,
                                                  backgroundColor:
                                                      Colors.grey[200],
                                                  labelStyle: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 20),
                                  Divider(),
                                  SizedBox(height: 15),

                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Word Pool:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),

                                  SizedBox(
                                    height: 275,
                                    child: Wrap(
                                      spacing: 8,
                                      children: [
                                        ...List.generate(
                                          currentSentence
                                              .scrambledSentance
                                              .length,
                                          (wordIndex) {
                                            final word = currentSentence
                                                .scrambledSentance[wordIndex];
                                            final isSelected = _attempts[index]
                                                .contains(word);
                                            return ChoiceChip(
                                              label: Text(word),
                                              selected: isSelected,
                                              onSelected: (selected) {
                                                setState(() {
                                                  if (selected) {
                                                    _attempts[index].add(word);
                                                  }
                                                });
                                              },
                                              selectedColor: Colors.blue,
                                              backgroundColor: Colors.grey[200],
                                              labelStyle: TextStyle(
                                                color: isSelected
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,

                                    children: [
                                      TextButton(
                                        onPressed: _attempts[index].isNotEmpty
                                            ? () {
                                                setState(() {
                                                  _attempts[index].clear();
                                                });
                                              }
                                            : null,
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              _attempts[index].isNotEmpty
                                              ? const Color.fromARGB(
                                                  255,
                                                  120,
                                                  165,
                                                  243,
                                                )
                                              : Colors.grey,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 20,
                                          ),
                                        ),
                                        child: Text(
                                          'Reset',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'serif',
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: _attempts[index].isNotEmpty
                                            ? () {
                                                final isCorrect =
                                                    validateAttempt(
                                                      currentSentence,
                                                      _attempts[index],
                                                    );

                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      isCorrect
                                                          ? ' Correct! Well done!'
                                                          : 'Incorrect. Try again!',
                                                    ),
                                                    backgroundColor: isCorrect
                                                        ? Colors.green
                                                        : Colors.red,
                                                    duration: Duration(
                                                      seconds: 2,
                                                    ),
                                                  ),
                                                );
                                              }
                                            : null,
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              _attempts[index].isNotEmpty
                                              ? const Color.fromARGB(
                                                  255,
                                                  120,
                                                  165,
                                                  243,
                                                )
                                              : Colors.grey,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 20,
                                          ),
                                        ),
                                        child: Text(
                                          'Validate Sentence',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'serif',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        if (currentIndex > 0) {
                          _pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: currentIndex > 0 ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                        child: SizedBox(
                          width: 120,
                          child: Row(
                            children: [
                              Icon(
                                Icons.keyboard_arrow_left,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Previous",
                                style: TextStyle(
                                  fontFamily: 'serif',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        if (currentIndex < _scrambledSentences.length - 1) {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          context.pop();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: currentIndex < _scrambledSentences.length - 1
                              ? Colors.blue
                              : Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                        child: SizedBox(
                          width: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (currentIndex <
                                  _scrambledSentences.length - 1) ...[
                                Text(
                                  "Next",
                                  style: TextStyle(
                                    fontFamily: 'serif',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.white,
                                ),
                              ] else ...[
                                Text(
                                  "Done",
                                  style: TextStyle(
                                    fontFamily: 'serif',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(Icons.check, color: Colors.white),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
