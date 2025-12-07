import 'package:flutter/material.dart';

class ImunisasiList extends StatelessWidget {
  final List<Map<String, dynamic>> balitas;
  final String searchQuery;
  final void Function(Map<String, dynamic>) onTapBalita;

  const ImunisasiList({
    super.key,
    required this.balitas,
    required this.searchQuery,
    required this.onTapBalita,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = balitas
        .where((b) =>
            b["nama"].toString().toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    if (filtered.isEmpty) {
      return const Center(
        child: Text(
          "Tidak ada data",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Judul utama
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            "Riwayat Imunisasi",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        // 🔹 List balita
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final balita = filtered[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Colors.blueAccent.shade200, // border biru
                      width: 2,
                    ),
                  ),
                  elevation: 6, // shadow lebih nyata
                  shadowColor: Colors.blueAccent.withOpacity(0.3),
                  color: Colors.white, // card putih
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => onTapBalita(balita),
                    splashColor: Colors.blueAccent.withOpacity(0.2),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          balita["nama"][0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        balita["nama"],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        "Tanggal Lahir: ${balita["tanggalLahir"]}",
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
