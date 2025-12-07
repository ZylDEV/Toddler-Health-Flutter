import 'package:flutter/material.dart';

class ImunisasiDetail extends StatelessWidget {
  final Map<String, dynamic> balita;
  final Map<String, dynamic> imunisasi;

  const ImunisasiDetail({
    super.key,
    required this.balita,
    required this.imunisasi,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    // Filter semua key yang bukan info balita
    final imunisasiEntries = imunisasi.entries.where((e) =>
        !['namaBalita', 'jenisKelamin', 'tanggalLahir', 'balitaId']
            .contains(e.key));

    // Pisahkan yang sudah ada data dan belum
    final sudahData = imunisasiEntries.where((e) {
      final val = e.value as Map<dynamic, dynamic>?;
      return val != null &&
          (val['tanggal']?.toString().isNotEmpty ?? false) &&
          (val['usia']?.toString().isNotEmpty ?? false);
    });

    final belumData = imunisasiEntries.where((e) {
      final val = e.value as Map<dynamic, dynamic>?;
      return val == null ||
          (val['tanggal']?.toString().isEmpty ?? true) ||
          (val['usia']?.toString().isEmpty ?? true);
    });

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16, 16 + topPadding, 16, 16),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Detail Imunisasi",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Informasi lengkap imunisasi balita",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Konten
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Info Balita
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.blue, width: 2), // border biru
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            balita['nama'] ?? '-',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _infoTile("Jenis Kelamin", balita['jenisKelamin']),
                            _infoTile("Tanggal Lahir", balita['tanggalLahir']),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Detail Imunisasi
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.blue, width: 2), // border biru
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Detail Imunisasi",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Semua data imunisasi beserta tanggal dan usia.",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),

                        // Bagian sudah ada data
                        if (sudahData.isNotEmpty) ...[
                          const Text(
                            "✅ Sudah Diberikan",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...sudahData.map((e) {
                            final val = e.value as Map<dynamic, dynamic>?;
                            final tanggal = val?['tanggal'] ?? '-';
                            final usia = val?['usia'] ?? '-';
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: const BorderSide(color: Colors.blue, width: 1),
                              ),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                title: Text(
                                  e.key,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text("Tanggal: $tanggal | Usia: $usia"),
                              ),
                            );
                          }).toList(),
                          const SizedBox(height: 16),
                        ],

                        // Bagian belum ada data
                        if (belumData.isNotEmpty) ...[
                          const Text(
                            "❌ Belum Diberikan",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...belumData.map((e) {
                            final val = e.value as Map<dynamic, dynamic>?;
                            final tanggal = val?['tanggal'] ?? '-';
                            final usia = val?['usia'] ?? '-';
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: const BorderSide(color: Colors.blue, width: 1),
                              ),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                                title: Text(
                                  e.key,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text("Tanggal: $tanggal | Usia: $usia"),
                              ),
                            );
                          }).toList(),
                        ],

                        const SizedBox(height: 16),
                        const Text(
                          "Keterangan: Pastikan imunisasi dilakukan sesuai jadwal dokter.",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String title, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value?.toString() ?? '-',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
