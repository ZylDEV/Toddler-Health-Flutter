import 'package:flutter/material.dart';

class ProfilBalitaCard extends StatelessWidget {
  final Map<String, dynamic> balita;

  const ProfilBalitaCard({super.key, required this.balita});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              balita['nama'] ?? "-",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.cake, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text("Tanggal Lahir: ${balita['tanggalLahir'] ?? '-'}"),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.male, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text("Jenis Kelamin: ${balita['jenisKelamin'] ?? '-'}"),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text("Tempat Lahir: ${balita['tempatLahir'] ?? '-'}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
