import 'package:flutter/material.dart';
import 'dart:async';
import 'quiz_manager.dart';
import 'result_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  QuizPageState createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  final QuizManager _quizManager = QuizManager();
  bool _answerWasSelected = false;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _updateProgress();
  }

  void _updateProgress() {
    setState(() {
      _progress = (_quizManager.questionIndex + 1) / _quizManager.totalQuestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quiz Mahasiswa Baru',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0A1F44),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF3B4CCA),
              Color(0xFF201B81),
              Color(0xFF13104E),
              Color(0xFF0D0B35),
              Color(0xFF0A0828),
              Color(0xFF07061B),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!_quizManager.isFinished)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white24,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            width: constraints.maxWidth * _progress,
                            height: 12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                colors: [Colors.greenAccent, Colors.blueAccent],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Text(
                      '${(_progress * 100).toInt()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(8),
                  child: Builder(
                    builder: (context) {
                      return _quizManager.isFinished
                          ? ResultPage(
                        key: ValueKey(_quizManager.score),
                        score: _quizManager.score,
                        resetQuiz: () {
                          setState(() {
                            _quizManager.resetQuiz();
                          });
                        },
                      )
                          : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 72, bottom: 80),
                            child: Text(
                              _quizManager.currentQuestion['question'] as String,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: (_quizManager.currentQuestion['answers'] as List<Map<String, Object>>)
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  int index = entry.key;
                                  Map<String, Object> answer = entry.value;
                                  Color buttonColor = index % 2 == 0
                                      ? const Color.fromARGB(255, 13, 71, 161)
                                      : const Color.fromARGB(255, 129, 212, 250);

                                  Color? backgroundColor;
                                  Color? borderColor;

                                  if (_answerWasSelected) {
                                    if (index == _quizManager.correctAnswerIndex) {
                                      backgroundColor = Colors.green;
                                      borderColor = Colors.green[800];
                                    } else if (index == _quizManager.selectedAnswerIndex) {
                                      backgroundColor = Colors.red;
                                      borderColor = Colors.red[800];
                                    }
                                  }

                                  return Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: ElevatedButton(
                                      onPressed: _answerWasSelected ? null : () {
                                        setState(() {
                                          _quizManager.answerQuestion(answer['score'] as int, index, (_quizManager.currentQuestion['answers'] as List<Map<String, Object>>).indexWhere((a) => a['score'] == 1));
                                          _answerWasSelected = true;
                                        });
                                        Timer(const Duration(seconds: 3), () {
                                          setState(() {
                                            _answerWasSelected = false;
                                            _quizManager.nextQuestion();
                                            _updateProgress();
                                          });
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(double.infinity, 125),
                                        padding: const EdgeInsets.all(20),
                                        textStyle: const TextStyle(fontSize: 18),
                                        backgroundColor: backgroundColor ?? buttonColor,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          side: borderColor != null ? BorderSide(color: borderColor, width: 10) : BorderSide.none,
                                        ),
                                        elevation: 5,
                                      ),

                                      child: Text(
                                        answer['text'] as String,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: index % 2 == 0 ? Colors.white : const Color.fromARGB(255, 13, 71, 161),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}