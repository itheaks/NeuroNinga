import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:neuroninja/smallnum.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '2numsumcomp.dart';
import 'chapter1.dart';
import 'chapter2.dart';
import 'chapter3.dart';
import 'chapter4.dart';
import 'chapter5.dart';
import 'chapter6.dart';
import 'chapter7.dart';
import 'chapter8.dart';
import 'colorfinder.dart';
import 'lucky.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'neuroNinja',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _animationController.forward();

    _checkLoggedInStatus(); // Check if user is already logged in
  }

  void _checkLoggedInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      // User is already logged in, navigate to the home page
      _navigateToHomePage();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _saveName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', name);
  }

  Future<void> _setLoggedInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  void _navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  void _continueToHomePage() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await _saveName(_nameController.text.trim());
      await _setLoggedInStatus(); // Set the logged-in status
      _navigateToHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter your name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimationLimiter(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 500),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 200.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: <Widget>[
                  SizedBox(height: 16.0),
                  Center(
                    child: Image.asset(
                      'assets/love2.gif',
                      width: 400,
                      height: 300,
                    ),
                  ),
                  TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _continueToHomePage,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('Continue'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late String _username;

  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  Future<void> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to neuroNinja $_username'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pinkAccent,
              Colors.white,
              // Colors.greenAccent,
              // Colors.blueAccent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            _buildScreens(),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SizedBox(
                height: kBottomNavigationBarHeight,
                child: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                      backgroundColor: Colors.pinkAccent,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.explore),
                      label: 'Explore',
                      backgroundColor: Colors.pinkAccent,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.search),
                      label: 'Luck',
                      backgroundColor: Colors.pinkAccent,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'About',
                      backgroundColor: Colors.pinkAccent,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreens() {
    final List<Widget> screens = [
      HomeScreen(),
      ExploreScreen(),
      ProgressScreen(),
      ProfileScreen(),
    ];
    return screens[_currentIndex];
  }
}

// flutter pub run flutter_launcher_icons:main

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight),
      crossAxisCount: 2,
      children: AnimationConfiguration.toStaggeredList(
    duration: const Duration(milliseconds: 500),
    childAnimationBuilder: (widget) => SlideAnimation(
    verticalOffset: 50.0,
    child: FadeInAnimation(
    child: widget,
    ),
    ),
      children: List.generate(8, (index) {
        final chapterNumber = index + 1;
        final chapterTitle = 'Chapter $chapterNumber';
        final chapterText = '${_getChapterText(index)}';
        return GestureDetector(
          onTap: () {
            if (index == 0){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Chapter1(), // Replace Chapter1 with your chapter1.dart class name
                ),
              );
            } else if (index == 1){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Chapter2(), // Replace Chapter2 with your chapter2.dart class name
                  ));
            } else if (index == 2){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Chapter3(), // Replace Chapter2 with your chapter2.dart class name
                  ));
            } else if (index == 3){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Chapter4(), // Replace Chapter2 with your chapter2.dart class name
                  ));
            } else if (index == 4){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Chapter5(), // Replace Chapter2 with your chapter2.dart class name
                  ));
            } else if (index == 5){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Chapter6(), // Replace Chapter2 with your chapter2.dart class name
                  ));
            } else if (index == 6){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Chapter7(), // Replace Chapter2 with your chapter2.dart class name
                  ));
            } else if (index == 7){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Chapter8(), // Replace Chapter2 with your chapter2.dart class name
                  ));
            }
          },

          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  //Colors.purpleAccent,
                  Colors.tealAccent,
                  Colors.indigoAccent
                ]
              ),
              borderRadius: BorderRadius.circular(50),
                boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: Offset(0, 4),
                            ),
                          ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    chapterTitle,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    chapterText,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      })),
    );
  }


  String _getChapterText(int index) {
    switch (index) {
      case 0:
        return 'Direction Sense Test';
      case 1:
        return 'Blood Relationship';
      case 2:
        return 'Number Series';
      case 3:
        return 'Analogy';
      case 4:
        return 'Classification';
      case 5:
        return 'Letter Series';
      case 6:
        return 'Coding Decoding';
      case 7:
        return 'Calender';
      default:
        return '';
    }
  }
}

class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight),
        itemCount: 3,
        itemBuilder: (context, index) {
          final chapterNumber = index + 1;
          final chapterTitle = 'Mind Game $chapterNumber';
          final chapterText = '${_getChapterText(index)}';
          return GestureDetector(
            onTap: () {
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NumberGame(),
                  ),
                );
              } else if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NumberComparisonGame(),
                  ),
                );
              } else if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ColorPage(),
                  ),
                );
              }
            },
            child: AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.tealAccent,
                          //Colors.white,
                          Colors.indigoAccent
                        ],
                      )
                    ),
                    height: 250,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            chapterTitle,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            chapterText,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  String _getChapterText(int index) {
    switch (index) {
      case 0:
        return 'Catch Smaller Number';
      case 1:
        return 'Compare Sum of Two Numbers';
      case 2:
        return 'Find My Color';
      default:
        return '';
    }
  }
}

class ProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.synchronized(
      duration: const Duration(milliseconds: 500),
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 500),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    'Check Your Luck by Clicking Button Down, a dice will appear which will show how lucky you are......',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LuckCheckerPage(),
                      ),
                    );
                  },
                  child: Text('Go to Luck Screen'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: AnimationConfiguration.synchronized(
          duration: const Duration(milliseconds: 500),
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 500),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        'Thanks for your Contribution by using our Platform NeuroNinja, We can ensure this will give you big advantage and your brain IQ level will increase if you daily practice 50 questions. This app provides you feature to Check Your Luck, Play Mind Games and Practice Reasoning question to Improve your IQ.',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}