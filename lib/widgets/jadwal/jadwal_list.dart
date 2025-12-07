import 'package:flutter/material.dart';

class JadwalList extends StatelessWidget {
  final List<Map<String, String>> jadwalList;

  const JadwalList({super.key, required this.jadwalList});

  @override
  Widget build(BuildContext context) {
    if (jadwalList.isEmpty) {
      return const Center(
        child: Text(
          "Tidak ada jadwal",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        // 🔹 Judul utama
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            "Jadwal Posyandu",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        // 🔹 List jadwal
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: jadwalList.length,
            itemBuilder: (_, index) {
              final jadwal = jadwalList[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Colors.blueAccent.shade200, // border biru
                      width: 2,
                    ),
                  ),
                  elevation: 6,
                  shadowColor: Colors.blueAccent.withOpacity(0.3),
                  color: Colors.white, // card putih
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.blueAccent.withOpacity(0.2),
                      child: Text(
                        jadwal["tanggal"]!.split("-")[0],
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      jadwal["deskripsi"]!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("Tanggal: ${jadwal["tanggal"]}",
                            style: const TextStyle(color: Colors.black54)),
                        Text("Waktu: ${jadwal["waktu"]}",
                            style: const TextStyle(color: Colors.black54)),
                        Text("Lokasi: ${jadwal["lokasi"]}",
                            style: const TextStyle(color: Colors.black54)),
                      ],
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
