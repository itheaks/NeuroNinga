import 'package:flutter/material.dart';

class Chapter7 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coding and Decoding',
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
      'In a certain code, INSTITUTION is written as NOITUTITSNI. How is PERFECTION written in that code?',
      ['NOICTEFREP', 'NOITCEFERP', 'NOITCEFRPE', 'NOITCEFREP'],
      'NOITCEFERP',
    ),
    Question(
      'In a certain code, GIGANTIC is written as GIGTANCI. How is MIRACLES written in that code?',
      ['MIRLCAES', 'MIRLACSE', 'RIMCALSE', 'RIMLCAES'],
      'MIRLACSE',
    ),
    Question(
      'In a certain code, GOODNESS is coded as HNPCODTR. How is GREATNESS coded in that code?',
      ['HQFZUODTR', 'HQFZUMFRT', 'HQFZSMFRT', 'FSDBSODTR'],
      'HQFZUMFRT',
    ),
    Question(
      'In a certain code, EXPLAINING is written as PXEALNIGNI. How is PRODUCED written in that code?',
      ['ORPBUDEC', 'ROPUDECD', 'ORPUDECD', 'None of these'],
      'ORPUDECD',
    ),
    Question(
      'In a certain code, RIPPLE is written as 613382 and LIFE is written as 8192. How is PILLER written in that code?',
      ['318826', '318286', '618826', '328816'],
      '318826',
    ),
    Question(
      'If PAINTER is written in a code language as NCGPRGP, then REASON would be written as -',
      ['PCYQMN', 'PGYQMN', 'PGYUMP', 'PGYUPM'],
      'PGYQMN',
    ),
    Question(
      'In a certain code SOCIAL is written as TQFMFR, then how you will code DIMPLE?',
      ['EKPTQK', 'EKPQPJ', 'EKPSPJ', 'EKPSOH'],
      'EKPQPJ',
    ),
    Question(
      'If CARPET is coded as TCEAPR, then the code for NATIONAL would be -',
      ['NLATNOIA', 'LANOITAN', 'LNAANTOI', 'LNOINTAA'],
      'LANOITAN',
    ),
    Question(
      'If PORTER is written as QNSSFQ, then BRIGHT would be coded as -',
      ['CQJFIS', 'CNJHIS', 'CQJFGS', 'CNJHIU'],
      'CQJHIS',
    ),
    Question(
      'If FESTIVAL is coded as MBWJUTFG, then OPIUM would be coded as -',
      ['NOHTL', 'NTHNO', 'NVJQP', 'MUIPO'],
      'NTHNO',
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
        title: Text('Coding and Decoding'),
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
              'We welcome you on our platform and want to give you your best this is one simple Coding and Decoding problem where you will find question related to it. There is no negative marking and you will get +1 score for your correct options. You will get 1 min for a question and timer will be available on above. Do it carefully as you will not able to come back. Wish you all the very best. Tick the box and proceed ahead.',
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
