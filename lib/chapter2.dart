import 'package:flutter/material.dart';

class Chapter2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Relationship',
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
      'A told B, "Yesterday I met the only brother of the daughter of my grandmother." Whom did A meet?',
      ['Cousin', 'Brother', 'Nephew', 'Father'],
      'Father',
    ),
    Question(
      'Pointing to a man in a photograph Reena said, "His mother\'s only daughter is my mother." How is Reena related to that man?',
      ['Nephew', 'Sister', 'Nice', 'Wife'],
      'Nice',
    ),
    Question(
      'Pointing to a man in a photograph, a woman said, "His brother\'s father is the only son of my grandfather." How is the woman related to the man in the photograph?',
      ['Mother', 'Sister', 'Aunt', 'Daughter'],
      'Sister',
    ),
    Question(
      'Pointing to a person, Rohit said to Neha, "His mother is the only daughter of your father." How is Neha related to the person?',
      ['Aunt', 'Mother', 'Daughter', 'Wife'],
      'Mother',
    ),
    Question(
      'Pointing to a man, a woman said. "He is the brother of my uncle\'s daughter." How is the man related to the woman?',
      ['Cousin', 'Son', 'Brother-in-law', 'Nephew'],
      'Cousin',
    ),
    Question(
      'If B says that his mother is the only daughter of A\'s mother, how is A related to B?',
      ['Son', 'Father', 'Brother', 'Uncle'],
      'Uncle',
    ),
    Question(
      'Pointing to a lady, a man said. "The son of her only brother is the brother of my wife." How is the lady related to the man?',
      ['Mother\'s sister', 'Grandmother', 'Sister of father-in-law', 'Mother-in-law'],
      'Sister of father-in-law',
    ),
    Question(
      'Introducing a man, a woman said, "He is the only son of my mother." How is the woman related to the man?',
      ['Mother', 'Cousin', 'Niece', 'Aunt'],
      'Niece',
    ),
    Question(
      'P is the brother of Q and R. S is R\'s mother. T is P\'s father. Which of the following statements cannot be definitely true?',
      ['Q is T\'s son', 'T is Q\'s father', 'S is P\'s mother', 'P is S\'s son'],
      'Q is T\'s son',
    ),
    Question(
      'In A + B means A is the brother of B, A ÷ B means A is the father of B, and A x B means A is the sister of B. Which of the following means M is the uncle of P?',
      ['M ÷ N x P', 'N x P ÷ M', 'M x S ÷ R + P', 'M + K ÷ T x P'],
      'M + K ÷ T x P',
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
        title: Text('Blood Relationship'),
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
              'We welcome you on our platform and want to give you your best this is one simple Blood relationship problem where you will find question related to it. There is no negative marking and you will get +1 score for your correct options. You will get 1 min for a question and timer will be available on above. Do it carefully as you will not able to come back. Wish you all the very best. Tick the box and proceed ahead.',
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
