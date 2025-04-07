import 'package:flutter/material.dart';
import 'welcome_page.dart'; // Import halaman welcome_page.dart

void main() {
  // Fungsi utama yang menjalankan aplikasi Flutter
  runApp(const MyApp()); // Menjalankan aplikasi MyApp
}

class MyApp extends StatelessWidget {
  // Widget utama aplikasi
  const MyApp({super.key}); // Konstruktor dengan key opsional

  @override
  Widget build(BuildContext context) {
    // Metode build yang membangun tampilan aplikasi
    return MaterialApp(
      title: 'Quiz Mahasiswa Baru', // Judul aplikasi
      theme: ThemeData(
        // Tema aplikasi
        primarySwatch: Colors.blue, // Warna utama aplikasi
        scaffoldBackgroundColor: Colors.blue.shade50, // Warna latar belakang Scaffold
        appBarTheme: const AppBarTheme(
          // Tema AppBar
          backgroundColor: Color(0xFF0A1F44), // Warna latar belakang AppBar
          foregroundColor: Colors.white, // Warna teks dan ikon AppBar
          elevation: 4, // Elevasi AppBar
          centerTitle: true, // Memusatkan judul AppBar
          titleTextStyle: TextStyle(
            // Gaya teks judul AppBar
            color: Colors.white, // Warna teks judul
            fontWeight: FontWeight.bold, // Tebal teks judul
            fontSize: 20, // Ukuran teks judul
          ),
          iconTheme: IconThemeData(color: Colors.white), // Tema ikon AppBar
        ),
      ),
      home: const WelcomePage(), // Halaman awal aplikasi adalah WelcomePage
    );
  }
}
