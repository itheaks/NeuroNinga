import 'package:flutter/material.dart';

class Chapter5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classification',
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
      'Q.1 (A) DBF (B) HFK (C) NLP (D) XVZ (E) USW',
      ['DBF', 'HFK', 'NLP', 'XVZ', 'USW'],
      'XVZ',
    ),
    Question(
      'Q.2 (A) NKMJ (B) FCEB (C) URTQ (D) KHJG (E) TQRP',
      ['NKMJ', 'FCEB', 'URTQ', 'KHJG', 'TQRP'],
      'FCEB',
    ),
    Question(
      'Q.3 (A) GT7 (B) IR9 (C) CX3 (D) MN13 (E) JP10',
      ['GT7', 'IR9', 'CX3', 'MN13', 'JP10'],
      'JP10',
    ),
    Question(
      'Q.4 (A) J30T (B) D22R (C) H26R (D) A28Z (E) B7E',
      ['J30T', 'D22R', 'H26R', 'A28Z', 'B7E'],
      'D22R',
    ),
    Question(
      'Q.5 (A) ZYW (B) SQN (C) GEB (D) MKH (E) JHE',
      ['ZYW', 'SQN', 'GEB', 'MKH', 'JHE'],
      'SQN',
    ),
    Question(
      'Q.6 (A) NOQT (B) DEHK (C) BCEH (D) RSUX (E) JKMP',
      ['NOQT', 'DEHK', 'BCEH', 'RSUX', 'JKMP'],
      'DEHK',
    ),
    Question(
      'Q.7 (A) YWU (B) NLJ (C) KIF (D) VTR (E) PNL',
      ['YWU', 'NLJ', 'KIF', 'VTR', 'PNL'],
      'PNL',
    ),
    Question(
      'Q.8 (A) LHJ (B) SOQ (C) ZVX (D) FBD (E) RMP',
      ['LHJ', 'SOQ', 'ZVX', 'FBD', 'RMP'],
      'FBD',
    ),
    Question(
      'Q.9 (A) GDFE (B) QMPO (C) TQSR (D) CZBA (E) JGIH',
      ['GDFE', 'QMPO', 'TQSR', 'CZBA', 'JGIH'],
      'TQSR',
    ),
    Question(
      'Q.10 (A) DEGJ (B) QRTW (C) JKNQ (D) YZBE (E) MNPS',
      ['DEGJ', 'QRTW', 'JKNQ', 'YZBE', 'MNPS'],
      'JKNQ',
    )

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
        title: Text('Classification'),
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
              'We welcome you on our platform and want to give you your best this is one simple Classification where you will find question related to it. There is no negative marking and you will get +1 score for your correct options. You will get 1 min for a question and timer will be available on above. Do it carefully as you will not able to come back. Wish you all the very best. Tick the box and proceed ahead.',
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
