import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(LuckCheckerApp());
}

class LuckCheckerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luck Checker',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: LuckCheckerPage(),
    );
  }
}

class LuckCheckerPage extends StatefulWidget {
  @override
  _LuckCheckerPageState createState() => _LuckCheckerPageState();
}

class _LuckCheckerPageState extends State<LuckCheckerPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  Color bgColor = Colors.purpleAccent.shade100;

  int diceNumber = 1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Set initial color based on the initial dice number
    updateBackgroundColor();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void rollDice() {
    setState(() {
      diceNumber = Random().nextInt(6) + 1;
    });

    _animationController.reset();
    _animationController.forward();

    // Update the background color based on the new dice number
    updateBackgroundColor();
  }

  void updateBackgroundColor() {
    setState(() {
      switch (diceNumber) {
        case 1:
          bgColor = Colors.redAccent.shade200;
          break;
        case 2:
          bgColor = Colors.orangeAccent.shade100;
          break;
        case 3:
          bgColor = Colors.yellowAccent.shade100;
          break;
        case 4:
          bgColor = Colors.yellowAccent.shade200;
          break;
        case 5:
          bgColor = Colors.greenAccent.shade100;
          break;
        case 6:
          bgColor = Colors.green.shade200;
          break;
        default:
          bgColor = Colors.purpleAccent.shade100;
      }
    });
  }

  String describeLuck() {
    String luckDescription = '';

    switch (diceNumber) {
      case 1:
        luckDescription = 'Bad luck!';
        break;
      case 2:
        luckDescription = 'Not so lucky.';
        break;
      case 3:
        luckDescription = 'Average luck.';
        break;
      case 4:
        luckDescription = 'Good luck!';
        break;
      case 5:
        luckDescription = 'Very lucky!';
        break;
      case 6:
        luckDescription = 'Extremely lucky!';
        break;
    }

    return luckDescription;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Luck Checker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animation.value,
                  child: Image.asset(
                    'assets/dice$diceNumber.png',
                    width: 200,
                    height: 200,
                  ),
                );
              },
            ),
            SizedBox(height: 32),
            Text(
              'Your luck: ${describeLuck()}',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: rollDice,
        child: Icon(Icons.play_arrow),
      ),
      backgroundColor: bgColor, // Set the background color
    );
  }
}
