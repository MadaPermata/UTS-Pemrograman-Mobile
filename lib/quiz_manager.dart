import 'dart:math'; // Import pustaka math untuk fungsi random

class QuizManager {
  // Kelas untuk mengelola logika kuis

  int _currentQuestionIndex = 0; // Indeks pertanyaan saat ini
  int _score = 0; // Skor pengguna
  int? _selectedAnswerIndex; // Indeks jawaban yang dipilih pengguna
  int? _correctAnswerIndex; // Indeks jawaban yang benar

  final Duration questionDuration = const Duration(seconds: 20); // Durasi waktu untuk setiap pertanyaan

  final List<Map<String, Object>> _originalQuestions = [
    // Daftar pertanyaan
    {
      'question': 'Siapa nama Koorprodi D4 Manajemen Informatika?',
      'answers': [
        {'text': 'Pak Deny', 'score': 0},
        {'text': 'Bu Ifa', 'score': 0},
        {'text': 'Pak Agung', 'score': 0},
        {'text': 'Pak Dodik', 'score': 1},
      ],
    },
    {
      'question':
      'D4 Manajemen Informatika merupakan bagian dari Fakultas apa?',
      'answers': [
        {'text': 'FMIPA', 'score': 0},
        {'text': 'FEB', 'score': 0},
        {'text': 'FVOKASI', 'score': 1},
        {'text': 'FIKK', 'score': 0},
      ],
    },
    {
      'question': 'Apa nama himpunan D4 Manajemen Informatika?',
      'answers': [
        {'text': 'HIMAFORTIC', 'score': 1},
        {'text': 'HIMTI', 'score': 0},
        {'text': 'HIMADEGA', 'score': 0},
        {'text': 'HIMTIK', 'score': 0},
      ],
    },
    {
      'question':
      'Apa gelar yang di dapatkan Lulusan D4 Manajemen Informatika UNESA?',
      'answers': [
        {'text': 'S.Kom', 'score': 0},
        {'text': 'S.T', 'score': 0},
        {'text': 'S.Tr.Kom', 'score': 1},
        {'text': 'S.H', 'score': 0},
      ],
    },
    {
      'question': 'Apa Bahasa pemrograman yang di ajarkan diawal perkuliahan?',
      'answers': [
        {'text': 'Python', 'score': 1},
        {'text': 'Dart', 'score': 0},
        {'text': 'C#', 'score': 0},
        {'text': 'C++', 'score': 0},
      ],
    },
    {
      'question':
      'Di gedung K berapa letak Lab Komputer D4 Manajemen Informatika?',
      'answers': [
        {'text': 'K2', 'score': 0},
        {'text': 'K3', 'score': 0},
        {'text': 'K9', 'score': 0},
        {'text': 'K10', 'score': 1},
      ],
    },
    {
      'question': 'Apa itu API?',
      'answers': [
        {'text': 'Alat Pengembangan Aplikasi', 'score': 0},
        {'text': 'Antarmuka Pemrograman Aplikasi', 'score': 1},
        {'text': 'Arsitektur Perangkat Lunak', 'score': 0},
        {'text': 'Aplikasi Pengolah Informasi', 'score': 0},
      ],
    },
    {
      'question': 'Bahasa pemrograman apa yang digunakan dalam Flutter?',
      'answers': [
        {'text': 'Java', 'score': 0},
        {'text': 'Dart', 'score': 1},
        {'text': 'Python', 'score': 0},
        {'text': 'Kotlin', 'score': 0},
      ],
    },
    {
      'question':
      'Framework apa yang digunakan untuk mobile development dengan Flutter?',
      'answers': [
        {'text': 'React Native', 'score': 0},
        {'text': 'Ionic', 'score': 0},
        {'text': 'Flutter SDK', 'score': 1},
        {'text': 'Xamarin', 'score': 0},
      ],
    },
    {
      'question': 'Siapa nama gaulnya dari rektor UNESA?',
      'answers': [
        {'text': 'Bro Hasan', 'score': 0},
        {'text': 'Pak Hasan', 'score': 0},
        {'text': 'Cak Hasan', 'score': 1},
        {'text': 'Mbah Hasan', 'score': 0},
      ],
    },
  ];

  late List<Map<String, Object>> _questions; // Daftar pertanyaan yang akan ditampilkan (diacak)

  QuizManager() {
    // Konstruktor QuizManager
    resetQuiz(); // Mengatur ulang kuis saat objek dibuat
  }

  Map<String, Object> get currentQuestion {
    // Getter untuk mendapatkan pertanyaan saat ini
    if (_currentQuestionIndex < _questions.length) {
      return _questions[_currentQuestionIndex];
    } else {
      return {'question': 'Quiz Selesai', 'answers': []}; // Mengembalikan pesan selesai jika semua pertanyaan sudah dijawab
    }
  }

  int get totalQuestions => _questions.length; // Getter untuk mendapatkan jumlah total pertanyaan
  int get score => _score; // Getter untuk mendapatkan skor pengguna
  int get questionIndex => _currentQuestionIndex; // Getter untuk mendapatkan indeks pertanyaan saat ini
  bool get isFinished => _currentQuestionIndex >= _questions.length; // Getter untuk memeriksa apakah kuis sudah selesai
  int? get selectedAnswerIndex => _selectedAnswerIndex; // Getter untuk mendapatkan indeks jawaban yang dipilih
  int? get correctAnswerIndex => _correctAnswerIndex; // Getter untuk mendapatkan indeks jawaban yang benar

  void answerQuestion(int score, int selectedIndex, int correctIndex) {
    // Metode untuk menangani jawaban pengguna
    _score += score; // Menambahkan skor
    _selectedAnswerIndex = selectedIndex; // Menyimpan indeks jawaban yang dipilih
    _correctAnswerIndex = correctIndex; // Menyimpan indeks jawaban yang benar
  }

  void resetQuiz() {
    // Metode untuk mengatur ulang kuis
    _questions = List.from(_originalQuestions); // Membuat salinan daftar pertanyaan asli
    _questions.shuffle(Random()); // Mengacak urutan pertanyaan
    _currentQuestionIndex = 0; // Mengatur indeks pertanyaan ke 0
    _score = 0; // Mengatur skor ke 0
    _selectedAnswerIndex = null; // Mengatur indeks jawaban yang dipilih ke null
    _correctAnswerIndex = null; // Mengatur indeks jawaban yang benar ke null
  }

  void nextQuestion() {
    // Metode untuk beralih ke pertanyaan berikutnya
    if (_currentQuestionIndex < _questions.length) {
      _currentQuestionIndex++; // Menaikkan indeks pertanyaan
      _selectedAnswerIndex = null; // Mengatur indeks jawaban yang dipilih ke null
      _correctAnswerIndex = null; // Mengatur indeks jawaban yang benar ke null
    }
  }
}