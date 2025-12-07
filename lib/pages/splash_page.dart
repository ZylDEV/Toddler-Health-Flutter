import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double _logoOpacity = 0;
  double _logoScale = 0.8;
  double _textOpacity = 0;
  double _loadingOpacity = 0;

  @override
  void initState() {
    super.initState();

    // Animasi berurutan
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _logoOpacity = 1;
        _logoScale = 1;
      });
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _textOpacity = 1;
      });
    });

    Future.delayed(const Duration(milliseconds: 1600), () {
      setState(() {
        _loadingOpacity = 1;
      });
    });

    // Cek SharedPreferences sebelum pindah
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    final prefs = await SharedPreferences.getInstance();

    final nik = prefs.getString('nikIbu');
    final namaIbu = prefs.getString('namaIbu');
    final namaAyah = prefs.getString('namaAyah');
    final alamat = prefs.getString('alamat');
    final password = prefs.getString('password');

    await Future.delayed(const Duration(seconds: 3)); // delay splash biar animasi muncul

    if (!mounted) return;

    if (nik != null && namaIbu != null) {
      // Sudah login → kirim semua data user ke MainPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainPage(
            userData: {
              'nikIbu': nik,
              'namaIbu': namaIbu,
              'namaAyah': namaAyah ?? '',
              'alamat': alamat ?? '',
              'password': password ?? '',
            },
          ),
        ),
      );
    } else {
      // Belum login → LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // BAGIAN TENGAH: LOGO + TEKS
            Expanded(
              flex: 7,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 800),
                      opacity: _logoOpacity,
                      child: AnimatedScale(
                        scale: _logoScale,
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutBack,
                        child: Image.asset(
                          'assets/logo.png',
                          width: 150,
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 800),
                      opacity: _textOpacity,
                      child: Column(
                        children: const [
                          Text(
                            "Posyandu Boughenvil",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Aplikasi Kesehatan Balita",
                            style: TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // BAGIAN BAWAH: LOADING
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    opacity: _loadingOpacity,
                    child: Lottie.asset(
                      'assets/loading.json',
                      width: 80,
                      height: 80,
                      repeat: true,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
