class QuizManager {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  int? _correctAnswerIndex;

  final List<Map<String, Object>> _questions = [
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
      'question': 'D4 Manajemen Informatika merupakan bagian dari Fakultas apa?',
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
      'question': 'Apa gelar yang di dapatkan Lulusan D4 Manajemen Informatika UNESA?',
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
      'question': 'Di gedung K berapa letak Lab Komputer D4 Manajemen Informatika?',
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
      'question': 'Framework apa yang digunakan untuk mobile development dengan Flutter?',
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

  Map<String, Object> get currentQuestion {
    if (_currentQuestionIndex < _questions.length) {
      return _questions[_currentQuestionIndex];
    } else {
      return {'question': 'Quiz Selesai', 'answers': []};
    }
  }

  int get totalQuestions => _questions.length;
  int get score => _score;
  int get questionIndex => _currentQuestionIndex;
  bool get isFinished => _currentQuestionIndex >= _questions.length;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  int? get correctAnswerIndex => _correctAnswerIndex;

  void answerQuestion(int score, int selectedIndex, int correctIndex) {
    _score += score;
    _selectedAnswerIndex = selectedIndex;
    _correctAnswerIndex = correctIndex;
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    _selectedAnswerIndex = null;
    _correctAnswerIndex = null;
  }

  void nextQuestion() {
    _currentQuestionIndex++;
  }
}