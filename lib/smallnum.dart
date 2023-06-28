import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NumberGame(),
    );
  }
}

class NumberGame extends StatefulWidget {
  @override
  _NumberGameState createState() => _NumberGameState();
}

class _NumberGameState extends State<NumberGame> {
  int currentNumber1 = 0;
  int currentNumber2 = 0;
  int score = 0;
  Timer? timer;
  bool introductionChecked = false;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startGame() {
    setState(() {
      score = 0;
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        generateRandomNumbers();
      });
    });
    Timer(Duration(seconds: 60), () {
      timer?.cancel();
      showGameOverDialog();
    });
  }

  void generateRandomNumbers() {
    final random = Random();
    currentNumber1 = random.nextInt(100);
    currentNumber2 = random.nextInt(100);
    while (currentNumber2 == currentNumber1) {
      currentNumber2 = random.nextInt(100);
    }
  }

  void handleNumberTap(int selectedNumber) {
    setState(() {
      if (selectedNumber == currentNumber1 && currentNumber1 < currentNumber2) {
        score++;
      } else if (selectedNumber == currentNumber2 && currentNumber2 < currentNumber1) {
        score++;
      } else {
        score--;
      }
      generateRandomNumbers();
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Time\'s up!'),
              SizedBox(height: 16),
              Text('Your Score: $score', style: TextStyle(fontSize: 18)),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Restart'),
              onPressed: () {
                Navigator.of(context).pop();
                startGame();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Game'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green, Colors.yellowAccent
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Score: $score',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 40),
              introductionChecked
                  ? Column(
                children: [
                  GestureDetector(
                    onTap: () => handleNumberTap(currentNumber1),
                    child: Text(
                      'Number 1: $currentNumber1',
                      style: TextStyle(fontSize: 36),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => handleNumberTap(currentNumber2),
                    child: Text(
                      'Number 2: $currentNumber2',
                      style: TextStyle(fontSize: 36),
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: startGame,
                    child: Text('Start'),
                  ),
                ],
              )
                  : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      'Are you ready for this small mind exercise game, here you have to choose smallest number out of two number and if your answer is correct you will gain +1 point else you will loose 1 point. Tick the button to show you are ready and start this one minute mind game',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 10),
                  Checkbox(
                    value: introductionChecked,
                    onChanged: (value) {
                      setState(() {
                        introductionChecked = value!;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
