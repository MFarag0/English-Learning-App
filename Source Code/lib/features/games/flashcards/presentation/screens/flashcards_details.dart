import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:flip_card/flip_card.dart';
import 'package:kalimati_app/features/games/flashcards/presentation/providers/flashcard_notifier.dart';
import 'package:kalimati_app/features/home/domain/entities/resource.dart';
import 'package:kalimati_app/features/home/domain/entities/resource_type_enum.dart';
import 'package:kalimati_app/features/home/domain/entities/word.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Flashcards extends ConsumerStatefulWidget {
  final String packageId;
  const Flashcards({super.key, required this.packageId});

  @override
  ConsumerState<Flashcards> createState() => _FlashcardsState();
}

class _FlashcardsState extends ConsumerState<Flashcards> {
  final _pageController = PageController();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final flashCards = ref.watch(flashcardNotifierProvider);

    return flashCards.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => Center(child: Text("Error loading flashcards")),
      data: (flashcards) {
        final currentPak = flashcards.firstWhere(
          (p) => p.packageId == widget.packageId,
        );
        final List<Word> words = currentPak.words;
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            backgroundColor: const Color.fromARGB(255, 120, 165, 243),
            title: Text(
              currentPak.title,
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
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 650,
                    child: Card(
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 30),
                          Expanded(
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: words.length,
                              itemBuilder: (context, index) {
                                final word = words[index];
                                final text = word.text;
                                final def = word.definitions[0];

                                final resources = word.sentences.isNotEmpty
                                    ? word.sentences.first.resources
                                    : const <Resource>[];

                                return FlipCard(
                                  direction: FlipDirection.HORIZONTAL,
                                  front: Column(
                                    children: [
                                      SizedBox(height: 20),
                                      if (resources.any(
                                        (r) => r.type == ResourceTypeEnum.photo,
                                      )) ...[
                                        Image.network(
                                          errorBuilder: (_, __, ___) {
                                            return Column(
                                              children: [
                                                Icon(
                                                  Icons.broken_image,
                                                  size: 60,
                                                ),
                                                SizedBox(height: 240),
                                              ],
                                            );
                                          },
                                          resources
                                              .firstWhere(
                                                (r) =>
                                                    r.type ==
                                                    ResourceTypeEnum.photo,
                                              )
                                              .url,
                                          height: 300,
                                          width: 300,
                                          fit: BoxFit.cover,
                                        ),
                                      ],

                                      SizedBox(height: 20),
                                      Text(
                                        text,
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                            255,
                                            78,
                                            77,
                                            77,
                                          ),
                                          fontFamily: 'serif',
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 200),
                                      Text(
                                        "Tap card to see definition",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'serif',
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),

                                  back: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        if (resources.any(
                                          (r) =>
                                              r.type == ResourceTypeEnum.video,
                                        )) ...[
                                          SizedBox(
                                            height: 300,
                                            width: 300,
                                            child: Column(
                                              children: [
                                                VideoPlayerScreen(
                                                  videoUrl: resources
                                                      .firstWhere(
                                                        (r) =>
                                                            r.type ==
                                                            ResourceTypeEnum
                                                                .video,
                                                      )
                                                      .url,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ] else ...[
                                          Image.network(
                                            errorBuilder: (_, __, ___) {
                                              return Column(
                                                children: [
                                                  Icon(
                                                    Icons.broken_image,
                                                    size: 60,
                                                  ),
                                                  SizedBox(height: 240),
                                                ],
                                              );
                                            },
                                            resources
                                                .firstWhere(
                                                  (r) =>
                                                      r.type ==
                                                      ResourceTypeEnum.photo,
                                                )
                                                .url,
                                            height: 300,
                                            width: 300,
                                            fit: BoxFit.cover,
                                          ),
                                        ],

                                        SizedBox(height: 20),
                                        Text(
                                          def.text,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color.fromARGB(
                                              255,
                                              78,
                                              77,
                                              77,
                                            ),
                                            fontFamily: 'serif',
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 80),
                                        resources.any(
                                              (r) =>
                                                  r.type ==
                                                  ResourceTypeEnum.website,
                                            )
                                            ? ElevatedButton(
                                                onPressed: () {
                                                  final urlSource = resources
                                                      .firstWhere(
                                                        (r) =>
                                                            r.type ==
                                                            ResourceTypeEnum
                                                                .website,
                                                      )
                                                      .url;
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          WebPage(
                                                            url: urlSource,
                                                          ),
                                                    ),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.grey,
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 20,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                ),
                                                child: Text(
                                                  "View Source Link",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
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
                            setState(() {
                              currentIndex -= 1;
                            });
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
                          if (currentIndex < words.length - 1) {
                            setState(() {
                              currentIndex += 1;
                            });
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: currentIndex < words.length - 1
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
                                if (currentIndex < words.length - 1) ...[
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
                                  InkWell(
                                    onTap: () {
                                      context.pop();
                                    },
                                    child: Row(
                                      children: [
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
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() =>
      _VideoPlayerScreenState(url: videoUrl);
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final String url;
  _VideoPlayerScreenState({required this.url});
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 210, 210, 210),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(aspectRatio: 16 / 9, child: VideoPlayer(_controller)),

          IconButton(
            onPressed: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              });
            },
            icon: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}

class WebPage extends StatefulWidget {
  final String url;

  const WebPage({super.key, required this.url});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.url)),
      body: WebViewWidget(controller: _controller),
    );
  }
}
