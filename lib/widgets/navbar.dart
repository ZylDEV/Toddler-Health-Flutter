import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/splash_page.dart';
import '../widgets/navbar/profil_balita_card.dart';
import '../widgets/navbar/profil_ibu_card.dart';

class NavBar extends StatefulWidget {
  final Map<String, String> userData; // data user login

  const NavBar({super.key, required this.userData});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  List<Map<String, String>> balitas = [];

  @override
  void initState() {
    super.initState();
    _loadBalitas();
  }

  void _loadBalitas() async {
    final dbRef = FirebaseDatabase.instance.ref().child('balita');
    final snapshot = await dbRef.get();

    if (snapshot.exists) {
      final allBalitas = snapshot.value as Map<dynamic, dynamic>;
      final filtered = allBalitas.entries
          .where((entry) => entry.value['nikIbu'] == widget.userData['nikIbu'])
          .map((entry) => Map<String, String>.from(entry.value))
          .toList();

      setState(() => balitas = filtered);
    }
  }

  Future<void> _logout() async {
    // Hapus data login dari SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Kembali ke SplashPage atau LoginPage
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SplashPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              "Profil",
              style: TextStyle(
                  fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),

          // Profil Ibu
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child:
                Text("Profil Ibu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ProfilIbuCard(userData: widget.userData),
          const Divider(height: 32),

          // Profil Balita
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text("Profil Balita",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ...balitas.map((balita) => ProfilBalitaCard(balita: balita)),
          const Divider(height: 32),

          // Tombol Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: OutlinedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                "Logout",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.red, // background merah
                side: const BorderSide(color: Colors.white, width: 2), // border putih
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
