import 'package:flutter/material.dart';
import 'quiz_page.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class ResultPage extends StatefulWidget {
  final int score;
  final VoidCallback resetQuiz;

  const ResultPage({super.key, required this.score, required this.resetQuiz});

  @override
  ResultPageStateClass createState() => ResultPageStateClass();
}

class ResultPageStateClass extends State<ResultPage> {
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter = ConfettiController(duration: const Duration(seconds: 10));
    _playConfetti();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  void _playConfetti() {
    if (widget.score == 10) {
      _controllerCenter.play();
    } else if (widget.score >= 7) {
      _controllerCenter.play();
    } else if (widget.score >= 5) {
      // Tidak ada animasi untuk skor 5-6
    } else {
      // Tidak ada animasi untuk skor 0-4
    }
  }

  String getResultMessage(int score) {
    if (score == 10) {
      return 'Sempurna! Anda ahli dalam D4 Manajemen Informatika!';
    } else if (score >= 7) {
      return 'Bagus! Anda memiliki pengetahuan yang baik!';
    } else if (score >= 5) {
      return 'Lumayan! Anda perlu belajar lebih banyak.';
    } else {
      return 'Maaf, Anda perlu belajar lebih banyak.';
    }
  }

  IconData getResultIcon(int score) {
    if (score == 10) {
      return Icons.star;
    } else if (score >= 7) {
      return Icons.thumb_up;
    } else if (score >= 5) {
      return Icons.lightbulb_outline;
    } else {
      return Icons.sentiment_dissatisfied;
    }
  }

  Color getResultColor(int score) {
    if (score == 10) {
      return Colors.greenAccent;
    } else if (score >= 7) {
      return Colors.blueAccent;
    } else if (score >= 5) {
      return Colors.orangeAccent;
    } else {
      return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          color: Colors.transparent,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Hasil Quiz',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: CircularProgressIndicator(
                          value: widget.score / 10,
                          strokeWidth: 10,
                          valueColor: AlwaysStoppedAnimation<Color>(getResultColor(widget.score)),
                          backgroundColor: Colors.white30,
                        ),
                      ),
                      Icon(
                        getResultIcon(widget.score),
                        size: 80,
                        color: getResultColor(widget.score),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    getResultMessage(widget.score),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Skor Anda: ${widget.score}/10',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      widget.resetQuiz();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const QuizPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Ulangi Quiz',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.score == 10) // Kondisi untuk skor sempurna
          ConfettiWidget(
            confettiController: _controllerCenter,
            blastDirection: pi / 2,
            emissionFrequency: 0.01, // Frekuensi emisi lebih tinggi
            numberOfParticles: 100, // Jumlah partikel lebih banyak
            gravity: 0.1,
            minBlastForce: 50, // Kekuatan ledakan minimal
            maxBlastForce: 100, // Kekuatan ledakan maksimal
            colors: const [
              Colors.yellow,
              Colors.amber,
              Colors.orange,
              Colors.red,
            ],
            particleDrag: 0.05, // Efek drag partikel
            shouldLoop: false, // Animasi tidak berulang
            blastDirectionality: BlastDirectionality.explosive, // Arah ledakan menyebar
            createParticlePath: (size) {
              return Path()
                ..addOval(Rect.fromCircle(center: Offset.zero, radius: size.width / 2)); // Bentuk partikel
            },
          )
        else
          ConfettiWidget(
            confettiController: _controllerCenter,
            blastDirection: pi / 2,
            emissionFrequency: 0.05,
            numberOfParticles: 50,
            gravity: 0.1,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
      ],
    );
  }
}