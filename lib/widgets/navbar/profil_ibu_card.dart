import 'package:flutter/material.dart';

class ProfilIbuCard extends StatelessWidget {
  final Map<String, String> userData;

  const ProfilIbuCard({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.blueAccent.shade200, // border biru
          width: 2,
        ),
      ),
      elevation: 6, // shadow lebih nyata
      shadowColor: Colors.blueAccent.withOpacity(0.3),
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.badge, color: Colors.blue),
            title: const Text("NIK Ibu"),
            subtitle: Text(userData['nikIbu'] ?? "-"),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.blue),
            title: const Text("Nama Ibu"),
            subtitle: Text(userData['namaIbu'] ?? "-"),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.person_outline, color: Colors.blue),
            title: const Text("Nama Ayah"),
            subtitle: Text(userData['namaAyah'] ?? "-"),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.blue),
            title: const Text("Alamat"),
            subtitle: Text(userData['alamat'] ?? "-"),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.blue),
            title: const Text("Password"),
            subtitle: Text(userData['password'] ?? "-"),
          ),
        ],
      ),
    );
  }
}
