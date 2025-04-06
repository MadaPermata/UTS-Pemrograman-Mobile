import 'package:flutter/material.dart';
import 'quiz_page.dart'; // Import halaman quiz_page.dart

class WelcomePage extends StatelessWidget {
  // Widget halaman selamat datang
  const WelcomePage({super.key}); // Konstruktor dengan key opsional

  @override
  Widget build(BuildContext context) {
    // Metode build yang membangun tampilan halaman selamat datang
    return Scaffold(
      body: LayoutBuilder(
        // LayoutBuilder untuk mendapatkan batasan ukuran dari parent
        builder: (context, constraints) {
          return SingleChildScrollView(
            // Widget yang memungkinkan scroll jika konten melebihi layar
            child: ConstrainedBox(
              // Widget yang memberikan batasan ukuran minimum pada child
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                // Widget yang membuat child mengambil tinggi minimum yang diperlukan
                child: Container(
                  // Container untuk latar belakang gradien
                  width: double.infinity, // Lebar container memenuhi layar
                  decoration: const BoxDecoration(
                    // Dekorasi latar belakang gradien
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
                  child: Padding(
                    // Padding untuk konten di dalam container
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      // Column untuk menyusun widget secara vertikal
                      mainAxisAlignment: MainAxisAlignment.center, // Memusatkan widget secara vertikal
                      children: [
                        Image.asset(
                          // Widget untuk menampilkan gambar logo
                          'images/mi.png',
                          width: constraints.maxWidth * 0.5, // Lebar gambar 50% dari lebar layar
                          height: constraints.maxWidth * 0.5, // Tinggi gambar 50% dari lebar layar
                        ),
                        const SizedBox(height: 20), // Spasi vertikal
                        const Text(
                          // Teks selamat datang
                          'Selamat Datang di\nQuiz Mahasiswa Baru!',
                          textAlign: TextAlign.center, // Teks rata tengah
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20), // Spasi vertikal
                        const Text(
                          // Teks deskripsi quiz
                          'Uji pengetahuanmu tentang D4 Manajemen Informatika dengan quiz seru ini!',
                          textAlign: TextAlign.center, // Teks rata tengah
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 30), // Spasi vertikal
                        ElevatedButton(
                          // Tombol untuk memulai quiz
                          onPressed: () {
                            // Navigasi ke halaman quiz_page.dart
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const QuizPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            // Gaya tombol
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            textStyle: const TextStyle(fontSize: 18),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            // Teks tombol
                            'Mulai Quiz',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}