import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Gamelist extends StatelessWidget {
  const Gamelist({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 202, 222, 240),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
               
                Card(
                  elevation: 3,
                  margin: EdgeInsets.all(20),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 25,
                      horizontal: 15,
                    ),
                    leading: Icon(Icons.flash_on, size: 40, color: Colors.blue),
                    title: Text(
                      "Flashcards",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Learn new words with flashcards by flipping cards and guessing the meaning of each word",
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right, size: 30),
                    onTap: () {
                      context.push('/flashcards');
                    },
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  elevation: 3,
                  margin: EdgeInsets.all(20),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 25,
                      horizontal: 15,
                    ),
                    leading: Icon(Icons.abc, size: 40, color: Colors.blue),
                    title: Text(
                      "Unscramble Sentences",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Improve your grammar skills by reordering words to form meaningful sentences",
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right, size: 30),
                    onTap: () {
                      context.push('/unscramble');
                    },
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  elevation: 3,
                  margin: EdgeInsets.all(20),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 25,
                      horizontal: 15,
                    ),
                    leading: Icon(
                      Icons.compare_arrows,
                      size: 40,
                      color: Colors.blue,
                    ),
                    title: Text(
                      "Matching Words",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Test your vocabulary by matching each word listed with its correct definition",
                    ),

                    trailing: Icon(Icons.keyboard_arrow_right, size: 30),
                    onTap: () {
                      context.push('/match');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
