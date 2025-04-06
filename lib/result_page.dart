import 'package:flutter/material.dart';
import 'quiz_page.dart'; // Import halaman kuis
import 'package:confetti/confetti.dart'; // Import pustaka confetti

class ResultPage extends StatefulWidget {
  // Widget halaman hasil kuis
  final int score; // Skor pengguna
  final int totalQuestions; // Jumlah total pertanyaan
  final VoidCallback resetQuiz; // Fungsi untuk mereset kuis

  const ResultPage({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.resetQuiz,
  });

  @override
  ResultPageStateClass createState() => ResultPageStateClass();
}

class ResultPageStateClass extends State<ResultPage> {
  // State untuk halaman hasil kuis
  late ConfettiController _controllerCenter; // Controller confetti
  late double _scorePercentage; // Persentase skor

  @override
  void initState() {
    // Metode inisialisasi state
    super.initState();
    _scorePercentage = widget.totalQuestions > 0
        ? (widget.score / widget.totalQuestions)
        : 0; // Menghitung persentase skor
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 3)); // Membuat controller confetti
    _playConfetti(); // Memainkan confetti jika skor cukup tinggi
  }

  @override
  void dispose() {
    // Metode dispose untuk membersihkan resource
    _controllerCenter.dispose(); // Membuang controller confetti
    super.dispose();
  }

  void _playConfetti() {
    // Metode untuk memainkan confetti
    if (_scorePercentage >= 0.5) {
      _controllerCenter.play(); // Memainkan confetti jika persentase skor >= 0.5
    }
  }

  String getResultMessage() {
    // Metode untuk mendapatkan pesan hasil berdasarkan persentase skor
    if (_scorePercentage == 1) return 'Sempurna! Kamu menguasai materi ini!';
    if (_scorePercentage >= 0.8) return 'Luar Biasa! Pengetahuanmu sangat baik!';
    if (_scorePercentage >= 0.6) return 'Bagus! Sedikit lagi menuju sempurna!';
    if (_scorePercentage >= 0.4) return 'Lumayan. Terus belajar, ya!';
    return 'Jangan menyerah! Coba lagi dan tingkatkan skormu!';
  }

  IconData getResultIcon() {
    // Metode untuk mendapatkan ikon hasil berdasarkan persentase skor
    if (_scorePercentage == 1) return Icons.emoji_events;
    if (_scorePercentage >= 0.8) return Icons.star;
    if (_scorePercentage >= 0.6) return Icons.thumb_up_alt;
    if (_scorePercentage >= 0.4) return Icons.sentiment_satisfied_alt;
    return Icons.sentiment_very_dissatisfied;
  }

  Color getResultColor() {
    // Metode untuk mendapatkan warna hasil berdasarkan persentase skor
    if (_scorePercentage == 1) return Colors.amber.shade600;
    if (_scorePercentage >= 0.8) return Colors.lightGreenAccent.shade400;
    if (_scorePercentage >= 0.6) return Colors.blueAccent.shade200;
    if (_scorePercentage >= 0.4) return Colors.orangeAccent.shade400;
    return Colors.redAccent.shade400;
  }

  @override
  Widget build(BuildContext context) {
    // Metode build
    Color resultColor = getResultColor(); // Mendapatkan warna hasil

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            // Background gradien
            width: double.infinity,
            height: double.infinity,
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
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Hasil Quiz',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 35),
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 160,
                            height: 160,
                            child: CircularProgressIndicator(
                              value: _scorePercentage,
                              strokeWidth: 12,
                              valueColor:
                              AlwaysStoppedAnimation<Color>(resultColor),
                              backgroundColor: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          Icon(getResultIcon(), size: 70, color: resultColor),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      getResultMessage(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, color: Colors.white, height: 1.4),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Skor: ${widget.score}/${widget.totalQuestions}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 45),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Ulangi Quiz'),
                      onPressed: () {
                        widget.resetQuiz(); // Mereset kuis
                        Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                              const QuizPage(), // Navigasi ke halaman kuis
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) =>
                                  FadeTransition(
                                      opacity: animation, child: child),
                              transitionDuration:
                              const Duration(milliseconds: 400),
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF13104E),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                        onPressed: () {
                          Navigator.maybePop(context); // Navigasi kembali
                        },
                        child: const Text("Keluar",
                            style: TextStyle(color: Colors.white70)))
                  ],
                ),
              ),
            ),
          ),
          Align(
            // Confetti
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controllerCenter,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 30,
              emissionFrequency: 0.05,
              minBlastForce: 5,
              maxBlastForce: 20,
              gravity: 0.2,
              colors: const [
                Colors.greenAccent,
                Colors.blueAccent,
                Colors.pinkAccent,
                Colors.orangeAccent,
                Colors.purpleAccent,
                Colors.yellowAccent
              ],
            ),
          ),
        ],
      ),
    );
  }
}