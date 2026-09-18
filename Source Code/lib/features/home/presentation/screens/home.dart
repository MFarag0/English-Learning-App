import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: const Color.fromARGB(255, 202, 222, 240),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 110),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    "Welcome to Kalimati App",
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'cursive',
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 87, 87, 87),
                    ),
                  ),
                ),

                SizedBox(height: 200),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    "Quick Access",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontFamily: 'serif',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 87, 87, 87),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 100,
                        width: 200,
                        child: InkWell(
                          onTap: () {
                            context.go('/packages');
                          },
                          child: Card(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.add_box,
                                    size: 40,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Explore Packages",
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 100,
                        width: 200,
                        child: InkWell(
                          onTap: () {
                            context.go('/games');
                          },
                          child: Card(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.school,
                                    size: 40,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Start Learning",
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 100,
                        width: 200,
                        child: InkWell(
                          onTap: () {
                            context.push('/login');
                          },
                          child: Card(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.manage_accounts,
                                    size: 40,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Manage Students",
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 100,
                        width: 200,
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("App Information"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Kalimati App v1.0"),
                                      SizedBox(height: 10),
                                      Text(
                                        "Developed by Team 6 - Mohamed, Rami, Khalid",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 10),
                                      Divider(),
                                      SizedBox(height: 10),
                                      Text(
                                        "This app is designed to help students learn new languages through interactive packages and games, where students can choose from a variety of games such as flashcards, matching words with definition, and unscrambling words to enhance their vocabulary and language skills.",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Close"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Card(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.info,
                                    size: 40,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Information",
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
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
      ),
    );
  }
}
