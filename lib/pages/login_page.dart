import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/main_page.dart';
import '../widgets/custom_text_field.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nikController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dbRef = FirebaseDatabase.instance.ref().child('users');

  bool _loading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _checkSavedLogin();
  }

  Future<void> _checkSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedNik = prefs.getString('nikIbu');
    final savedNama = prefs.getString('namaIbu');
    final savedNamaAyah = prefs.getString('namaAyah');
    final savedAlamat = prefs.getString('alamat');
    final savedPassword = prefs.getString('password');

    if (savedNik != null && savedNama != null) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainPage(userData: {
            'nikIbu': savedNik,
            'namaIbu': savedNama,
            'namaAyah': savedNamaAyah ?? '',
            'alamat': savedAlamat ?? '',
            'password': savedPassword ?? '',
          }),
        ),
      );
    }
  }

  Future<void> _handleLogin() async {
    final nik = _nikController.text.trim();
    final password = _passwordController.text;

    if (nik.isEmpty || password.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("NIK dan Password harus diisi")),
      );
      return;
    }

    if (nik.length != 16) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("NIK harus terdiri dari 16 angka")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final snapshot = await _dbRef.get();
      Map<String, String>? currentUser;
      bool found = false;

      if (snapshot.exists) {
        final users = snapshot.value as Map<dynamic, dynamic>;
        for (var value in users.values) {
          final userMap = Map<String, dynamic>.from(value);
          if (userMap['nikIbu'] == nik && userMap['password'] == password) {
            found = true;
            currentUser = {
              'nikIbu': userMap['nikIbu'] ?? '',
              'namaIbu': userMap['namaIbu'] ?? '',
              'namaAyah': userMap['namaAyah'] ?? '',
              'alamat': userMap['alamat'] ?? '',
              'password': userMap['password'] ?? '',
            };
            break;
          }
        }
      }

      if (!mounted) return;
      setState(() => _loading = false);

      if (found && currentUser != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('nikIbu', currentUser['nikIbu']!);
        await prefs.setString('namaIbu', currentUser['namaIbu']!);
        await prefs.setString('namaAyah', currentUser['namaAyah']!);
        await prefs.setString('alamat', currentUser['alamat']!);
        await prefs.setString('password', currentUser['password']!);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainPage(userData: currentUser!)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("NIK atau Password salah")),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', width: 150, height: 150),
              const SizedBox(height: 20),
              const Text(
                "Login",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                controller: _nikController,
                hintText: "NIK Ibu",
                icon: Icons.person,
                keyboardType: TextInputType.number,
                maxLength: 16,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                hintText: "Password",
                icon: Icons.lock,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
              if (_loading) ...[
                Lottie.asset('assets/loading.json', width: 80, height: 80),
                const SizedBox(height: 16),
              ],
              // 🔹 Tombol Login Biru Border, Background Putih, Text Biru
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: OutlinedButton(
                  onPressed: _loading ? null : _handleLogin,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.blue, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
