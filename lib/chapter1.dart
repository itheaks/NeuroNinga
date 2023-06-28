import 'package:flutter/material.dart';

class Chapter1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Direction Sense Test',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: QuizApp(),
    );
  }
}

class QuizApp extends StatefulWidget {
  @override
  _QuizAppState createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  final List<Question> questions = [
    Question(
      'A man is facing south. He turns 135º in the anticlockwise direction and then 180º in the clockwise direction. Which direction is he facing now?',
      ['North-east', 'North-west', 'South-east', 'South-west'],
      'South-west',
    ),
    Question(
      'A man is facing north-west. He turns 90º in the clockwise direction and then 135º in the anticlockwise direction. Which direction is he facing now?',
      ['East', 'West', 'North', 'South'],
      'North',
    ),
    Question(
      'A man is facing north-west. He turns 90º in the clockwise direction, then 180º in the anticlockwise direction and then another 90º in the same direction. Which direction is he facing now?',
      ['South', 'South-west', 'West', 'South-east'],
      'West',
    ),
    Question(
      'I am facing east. I turn 100º in the clockwise direction and then 145º in the anticlockwise direction. Which direction am I facing now?',
      ['East', 'North-east', 'North', 'South-west'],
      'North-west',
    ),
    Question(
      'Deepak starts walking straight towards east. After walking 75 metres, he turns to the left and walks 25 metres straight. Again he turns to the left, walks a distance of 40 metres straight, again he turns to the left and walks a distance of 25 metres. How far is he from the starting point?',
      ['25 metres', '50 metres', '140 metres', 'None of these'],
      '50 metres',
    ),
    Question(
      'Kishenkant walks 10 kilometres towards North. From there, he walks 6 kilometres towards South. then, he walks 3 kilometres towards East. How far and in which direction is he with reference to his starting point?',
      ['5 kilometres West', '5 kilometres North-east', '7 kilometres East', '7 kilometres West'],
      '7 kilometres West',
    ),
    Question(
      'Gaurav walks 20 metres towards North. He then turns left and walks 40 metres. He again turns left and walks 20 metres. Further, he moves 20 metres after turning to the right. How far is he from his original position?',
      ['20 metres', '30 metres', '60 metres', 'None of these'],
      '20 metres',
    ),
    Question(
      'Radha moves towards South-East a distance of 7 km, then she moves towards West and travels a distance of 14 m. From here, she moves towards North-west a distance of 7 m and finally she moves a distance of 4 m towards East and stood at that point. How far is the starting point from where she stood?',
      ['3 m', '4 m', '10 m', '11 m'],
      '10 m',
    ),
    Question(
      'Gopal starts from his house towards West. After walking distance of 30 metres, he turned towards right and walked 20 metres. He then turned left and moving a distance of 10 metres, turned to his left again and walked 40 metres. He now turns to the left and walks 5 metres. Finally he turns to his left. In which direction is he walking now?',
      ['North', 'South', 'East', 'West'],
      'South',
    ),
    Question(
      'A girl leaves from her home. She first walks 30 metres in North-west direction and then 30 metres in South-west direction. Next, she walks 30 metres in South-east direction. Finally, she turns towards her house. In which direction is she moving?',
      ['North-east', 'North-west', 'South-west','None of These'],
      'North-east',
    ),
  ];

  int currentQuestionIndex = 0;
  int score = 0;
  int totalTime = 0;
  int timeLeft = 600;
  bool quizStarted = false;
  bool introductionChecked = false;

  void startQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      totalTime = 0;
      timeLeft = 600;
      quizStarted = true;
      startTimer();
    });
  }

  void startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        timeLeft--;
        totalTime++;
        if (timeLeft > 0) {
          startTimer();
        } else {
          endQuiz();
        }
      });
    });
  }

  void answerQuestion(String selectedOption) {
    if (selectedOption == questions[currentQuestionIndex].correctAnswer) {
      setState(() {
        score++;
      });
    }
    goToNextQuestion();
  }

  void goToNextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        totalTime = 0;
      } else {
        endQuiz();
      }
    });
  }

  void endQuiz() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int totalQuestions = questions.length;
        double percentage = (score / totalQuestions) * 100;
        double accuracy = (score / totalQuestions);
        double avgTimePerQuestion = totalTime / totalQuestions;

        return AlertDialog(
          title: Text('Quiz Finished'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Score: $score'),
              SizedBox(height: 8),
              Text('Percentage: ${percentage.toStringAsFixed(2)}%'),
              SizedBox(height: 8),
              Text('Accuracy: ${(accuracy * 100).toStringAsFixed(2)}%'),
              SizedBox(height: 8),
              Text('Average Time per Question: ${avgTimePerQuestion.toStringAsFixed(2)} seconds'),
            ],
          ),
          actions: [
            OutlinedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            OutlinedButton(
              child: Text('Restart'),
              onPressed: () {
                Navigator.of(context).pop();
                startQuiz();
              },
            ),
          ],
        );
      },
    );

    setState(() {
      quizStarted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Direction Sense Test'),
      ),
      body: Center(
        child: quizStarted ? buildQuizContent() : buildStartButton(),
      ),
    );
  }

  Widget buildStartButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue,
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'We welcome you on our platform and want to give you your best this is one simple Direction Sense Test problem where you will find question related to it. There is no negative marking and you will get +1 score for your correct options. You will get 1 min for a question and timer will be available on above. Do it carefully as you will not able to come back. Wish you all the very best. Tick the box and proceed ahead.',
              style: TextStyle(fontSize: 24),
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
          ElevatedButton(
            child: Text('Start Quiz'),
            onPressed: introductionChecked ? startQuiz : null,
          ),
        ],
      ),
    );
  }


  Widget buildQuizContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orangeAccent,
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Time left: $timeLeft seconds',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          Text(
            'Score: $score',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          Text(
            'Question ${currentQuestionIndex + 1}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            '*******************************************',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            questions[currentQuestionIndex].question,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          Column(
            children: List.generate(
              questions[currentQuestionIndex].options.length,
                  (index) {
                return ElevatedButton(
                  child: Text(questions[currentQuestionIndex].options[index]),
                  onPressed: () {
                    answerQuestion(questions[currentQuestionIndex].options[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Question {
  final String question;
  final List<String> options;
  final String correctAnswer;

  Question(this.question, this.options, this.correctAnswer);
}
