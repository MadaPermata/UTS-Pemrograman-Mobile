import 'package:flutter/material.dart';
import 'dart:async';
import 'quiz_manager.dart';
import 'result_page.dart';

class QuizPage extends StatefulWidget {
  // Widget halaman Quiz
  const QuizPage({super.key});

  @override
  QuizPageState createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage>
    with SingleTickerProviderStateMixin {
  // State untuk halaman kuis dengan SingleTickerProviderStateMixin untuk animasi

  final QuizManager _quizManager =
      QuizManager(); // Objek QuizManager untuk mengelola logika kuis
  bool _answerWasSelected =
      false; // Flag untuk menandai apakah jawaban sudah dipilih
  double _progress = 0.0; // Progres kuis

  Timer? _questionTimer; // Timer untuk menghitung waktu pertanyaan
  late int _remainingTime; // Sisa waktu pertanyaan

  late AnimationController _scoreAnimationController; // Controller animasi skor
  late Animation<Offset> _scoreOffsetAnimation; // Animasi offset skor
  late Animation<double> _scoreFadeAnimation; // Animasi fade skor
  bool _showPlusOne = false; // Flag untuk menampilkan animasi skor
  String _pointsToAddText = "+1"; // Teks skor yang ditampilkan

  @override
  void initState() {
    // Metode inisialisasi state
    super.initState();
    _initializeQuiz(); // Memanggil metode inisialisasi kuis
  }

  void _initializeQuiz() {
    // Metode untuk menginisialisasi kuis
    _quizManager.resetQuiz(); // Mengatur ulang kuis
    _answerWasSelected = false; // Mengatur flag jawaban ke false
    _showPlusOne = false; // Mengatur flag animasi skor ke false
    _updateProgress(); // Memperbarui progres kuis

    _remainingTime = _quizManager
        .questionDuration.inSeconds; // Mengatur sisa waktu pertanyaan
    _startQuestionTimer(); // Memulai timer pertanyaan

    _scoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    ); // Menginisialisasi controller animasi skor
    _scoreOffsetAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: const Offset(0, -1.5))
            .animate(CurvedAnimation(
                parent: _scoreAnimationController,
                curve: Curves
                    .easeOutCubic)); // Menginisialisasi animasi offset skor
    _scoreFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _scoreAnimationController,
            curve: const Interval(0.4, 1.0,
                curve: Curves.easeOut))); // Menginisialisasi animasi fade skor
  }

  @override
  void dispose() {
    // Metode dispose untuk membersihkan resource
    _questionTimer?.cancel(); // Membatalkan timer pertanyaan
    _scoreAnimationController.dispose(); // Membuang controller animasi skor
    super.dispose();
  }

  void _updateProgress() {
    // Metode untuk memperbarui progres kuis
    if (!mounted) {
      return;
    }
    setState(() {
      _progress = _quizManager.totalQuestions > 0
          ? (_quizManager.questionIndex) / _quizManager.totalQuestions
          : 0;
    });
  }

  void _startQuestionTimer() {
    // Metode untuk memulai timer pertanyaan
    _questionTimer?.cancel(); // Membatalkan timer sebelumnya
    _remainingTime =
        _quizManager.questionDuration.inSeconds; // Mengatur sisa waktu
    if (mounted) {
      setState(() {});
    }

    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Timer periodik setiap detik
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_remainingTime > 0 && !_answerWasSelected) {
          _remainingTime--; // Mengurangi sisa waktu
        } else if (_remainingTime == 0 && !_answerWasSelected) {
          timer.cancel();
          _handleTimeout(); // Menangani timeout
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _handleTimeout() {
    // Metode untuk menangani timeout
    if (_answerWasSelected || !mounted) {
      return;
    }

    setState(() {
      _quizManager.answerQuestion(
          0,
          -1,
          (_quizManager.currentQuestion['answers'] as List)
              .indexWhere((a) => a['score'] == 1)); // Menyimpan jawaban timeout
      _answerWasSelected = true;
    });
    _moveToNextQuestionAfterDelay(); // Pindah ke pertanyaan berikutnya setelah delay
  }

  void _showPointsAnimation(int scoreGained) {
    // Metode untuk menampilkan animasi skor
    if (!mounted || scoreGained <= 0) {
      return;
    }
    setState(() {
      _pointsToAddText = "+$scoreGained"; // Mengatur teks skor
      _showPlusOne = true; // Menampilkan animasi
    });
    _scoreAnimationController.forward(from: 0.0).whenCompleteOrCancel(() {
      // Menjalankan animasi
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() => _showPlusOne = false); // Menyembunyikan animasi
        }
      });
    });
  }

  void _moveToNextQuestionAfterDelay() {
    // Metode untuk pindah ke pertanyaan berikutnya setelah delay
    const feedbackDuration = Duration(seconds: 2);
    Timer(feedbackDuration, () {
      if (mounted) {
        _quizManager.nextQuestion(); // Pindah ke pertanyaan berikutnya
        _answerWasSelected = false; // Mengatur flag jawaban ke false
        _updateProgress(); // Memperbarui progres

        if (_quizManager.isFinished) {
          _navigateToResultPage(); // Navigasi ke halaman hasil
        } else {
          setState(() {
            _startQuestionTimer(); // Memulai timer pertanyaan
          });
        }
      }
    });
  }

  void _navigateToResultPage() {
    // Metode untuk navigasi ke halaman hasil
    _questionTimer?.cancel(); // Membatalkan timer pertanyaan
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ResultPage(
          score: _quizManager.score,
          totalQuestions: _quizManager.totalQuestions,
          resetQuiz: () {
            if (mounted) {
              setState(() {
                _initializeQuiz(); // Menginisialisasi kuis
              });
            }
          },
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Metode build
    return PopScope(
        canPop: _quizManager.isFinished,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop && !_quizManager.isFinished) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Selesaikan quiz terlebih dahulu!"),
              duration: Duration(seconds: 2),
            ));
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Quiz Mahasiswa Baru'),
            automaticallyImplyLeading: false,
            actions: [
              if (!_quizManager.isFinished && !_answerWasSelected)
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Center(
                    child: Chip(
                      avatar: Icon(Icons.timer_outlined,
                          size: 18,
                          color: _remainingTime <= 5
                              ? Colors.red.shade700
                              : Colors.white),
                      label: Text(
                        _remainingTime.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: _remainingTime <= 5
                              ? Colors.red.shade700
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: _remainingTime <= 5
                          ? Colors.amber.shade300.withOpacity(0.85)
                          : Colors.black.withOpacity(0.25),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 0),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
              if (_quizManager.isFinished)
                IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close))
            ],
          ),
          body: Stack(
            children: [
              Container(
                // Background
                width: double.infinity, height: double.infinity,
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
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!_quizManager.isFinished)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
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
                                      duration:
                                          const Duration(milliseconds: 500),
                                      width: constraints.maxWidth * _progress,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Colors.greenAccent,
                                            Colors.blueAccent
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (!_quizManager.isFinished)
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Text(
                            "Soal ${_quizManager.questionIndex + 1} dari ${_quizManager.totalQuestions}",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 60),
                                child: Text(
                                  _quizManager.currentQuestion['question']
                                      as String,
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: (_quizManager
                                          .currentQuestion['answers'] as List)
                                      .length,
                                  itemBuilder: (context, index) {
                                    Map<String, Object> answer = (_quizManager
                                            .currentQuestion['answers']
                                        as List<Map<String, Object>>)[index];
                                    Color defaultButtonColor = index % 2 == 0
                                        ? const Color(0xFF283593)
                                        : const Color(0xFF1E88E5);
                                    Color defaultTextColor = Colors.white;
                                    Color currentBackgroundColor =
                                        defaultButtonColor;
                                    Color currentTextColor = defaultTextColor;
                                    IconData? leadingIcon;
                                    double elevation = 3;
                                    int? correctIndex =
                                        _quizManager.correctAnswerIndex;
                                    int? selectedIndex =
                                        _quizManager.selectedAnswerIndex;
                                    if (_answerWasSelected) {
                                      bool isCorrect = answer['score'] == 1;
                                      if (isCorrect) {
                                        currentBackgroundColor =
                                            Colors.green.shade700;
                                        currentTextColor = Colors.white;
                                        leadingIcon =
                                            Icons.check_circle_outline;
                                        elevation = 5;
                                      } else if (index == selectedIndex) {
                                        currentBackgroundColor =
                                            Colors.red.shade800;
                                        currentTextColor = Colors.white;
                                        leadingIcon = Icons.highlight_off;
                                        elevation = 2;
                                      } else {
                                        currentBackgroundColor = Colors
                                            .grey.shade800
                                            .withOpacity(0.7);
                                        currentTextColor = Colors.white54;
                                        elevation = 1;
                                      }
                                    }
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      child: ElevatedButton(
                                        onPressed: _answerWasSelected
                                            ? null
                                            : () {
                                                _questionTimer?.cancel();
                                                int correctAnswerIdx =
                                                    (_quizManager.currentQuestion[
                                                                'answers']
                                                            as List<
                                                                Map<String,
                                                                    Object>>)
                                                        .indexWhere((a) =>
                                                            a['score'] == 1);
                                                int scoreGained =
                                                    answer['score'] as int;
                                                bool isCorrect =
                                                    scoreGained > 0;
                                                setState(() {
                                                  _quizManager.answerQuestion(
                                                      scoreGained,
                                                      index,
                                                      correctAnswerIdx);
                                                  _answerWasSelected = true;
                                                });
                                                if (isCorrect) {
                                                  _showPointsAnimation(
                                                      scoreGained);
                                                }
                                                _moveToNextQuestionAfterDelay();
                                              },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 45),
                                          backgroundColor:
                                              currentBackgroundColor,
                                          foregroundColor: currentTextColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          elevation: elevation,
                                          disabledBackgroundColor:
                                              currentBackgroundColor,
                                          disabledForegroundColor:
                                              currentTextColor,
                                        ).copyWith(
                                          overlayColor: WidgetStateProperty
                                              .resolveWith<Color?>(
                                            (Set<WidgetState> states) {
                                              if (states.contains(
                                                  WidgetState.pressed)) {
                                                return Colors.white
                                                    .withOpacity(0.12);
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (leadingIcon != null &&
                                                _answerWasSelected)
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10.0),
                                                  child: Icon(leadingIcon,
                                                      size: 20))
                                            else if (_answerWasSelected)
                                              const SizedBox(width: 30),
                                            Expanded(
                                                child: Text(
                                              answer['text'] as String,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                            if (leadingIcon != null &&
                                                _answerWasSelected)
                                              const SizedBox(width: 30)
                                            else if (_answerWasSelected)
                                              const SizedBox(width: 30),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_showPlusOne)
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.15,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: IgnorePointer(
                      child: FadeTransition(
                        opacity: _scoreFadeAnimation,
                        child: SlideTransition(
                          position: _scoreOffsetAnimation,
                          child: Text(
                            _pointsToAddText,
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.amberAccent.shade400,
                              shadows: [
                                Shadow(
                                    blurRadius: 8.0,
                                    color: Colors.black.withOpacity(0.7),
                                    offset: Offset(2, 2))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}
