import 'package:flutter/material.dart';

class Chapter8 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calender',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
      'It was Sunday on Jan 1, 2006. What was the day of the week Jan 1, 2010?',
      ['Sunday', 'Saturday', 'Friday', 'Wednesday'],
      'Friday',
    ),
    Question(
      'What was the day of the week on 28th May, 2006?',
      ['Thursday', 'Friday', 'Saturday', 'Sunday'],
      'Sunday',
    ),
    Question(
      'What was the day of the week on 17th June, 1998?',
      ['Monday', 'Tuesday', 'Wednesday', 'Thursday'],
      'Wednesday',
    ),
    Question(
      'What will be the day of the week 15th August, 2010?',
      ['Sunday', 'Monday', 'Tuesday', 'Friday'],
      'Sunday',
    ),
    Question(
      'Today is Monday. After 61 days, it will be:',
      ['Wednesday', 'Saturday', 'Tuesday', 'Thursday'],
      'Thursday',
    ),
    Question(
      'If 6th March, 2005 is Monday, what was the day of the week on 6th March, 2004?',
      ['Sunday', 'Saturday', 'Tuesday', 'Wednesday'],
      'Sunday',
    ),
    Question(
      'On what dates of April, 2001 did Wednesday fall?',
      ['1st, 8th, 15th, 22nd, 29th', '2nd, 9th, 16th, 23rd, 30th', '3rd, 10th, 17th, 24th', '4th, 11th, 18th, 25th'],
      '4th, 11th, 18th, 25th',
    ),
    Question(
      'How many days are there in x weeks x days?',
      ['7x2', '8x', '14x', '7'],
      '7x2',
    ),
    Question(
      'The last day of a century cannot be',
      ['Monday', 'Wednesday', 'Tuesday', 'Friday'],
      'Tuesday',
    ),
    Question(
      'On 8th Feb, 2005 it was Tuesday. What was the day of the week on 8th Feb, 2004?',
      ['Tuesday', 'Monday', 'Sunday', 'Wednesday'],
      'Monday',
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
        title: Text('Calender'),
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
              'We welcome you on our platform and want to give you your best this is one simple Calender problem where you will find question related to it. There is no negative marking and you will get +1 score for your correct options. You will get 1 min for a question and timer will be available on above. Do it carefully as you will not able to come back. Wish you all the very best. Tick the box and proceed ahead.',
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
