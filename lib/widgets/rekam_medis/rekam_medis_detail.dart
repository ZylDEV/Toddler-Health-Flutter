import 'package:flutter/material.dart';

class RekamMedisDetail extends StatelessWidget {
  final Map<String, dynamic> rekamMedis;

  const RekamMedisDetail({super.key, required this.rekamMedis});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16, 16 + topPadding, 16, 16),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Detail Rekam Medis",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Informasi lengkap balita dan data kesehatan",
                        style: TextStyle(
                          color: Colors.white.withAlpha(230),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          // KONTEN UTAMA
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // INFORMASI PRIBADI BALITA
                  _buildPersonalInfoCard(context),
                  const SizedBox(height: 24),

                  // HASIL REKAM MEDIS
                  _buildHealthRecordCard(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- KARTU INFORMASI PRIBADI BALITA ---
  Widget _buildPersonalInfoCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blue, width: 2), // border biru
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
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
              rekamMedis['namaBalita'] ?? 'Nama Balita',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),
          const Divider(height: 20),
          _buildDataRow("Tanggal Lahir", rekamMedis['tanggalLahir']),
          _buildDataRow("Jenis Kelamin", rekamMedis['jenisKelamin']),
          _buildDataRow("Usia", rekamMedis['usia']),
        ],
      ),
    );
  }

  // --- KARTU HASIL REKAM MEDIS ---
  Widget _buildHealthRecordCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blue, width: 2), // border biru
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
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
            "Hasil Pemeriksaan Kesehatan",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(height: 20),
          _buildDataRow("Berat Badan (BB)", rekamMedis['bb']),
          _buildDataRow("Tinggi Badan (TB)", rekamMedis['tj']),
          _buildDataRow("Lingkar Kepala (LK)", rekamMedis['lk']),
          _buildDataRow("Lingkar Lengan Atas (LL)", rekamMedis['ll']),
          _buildDataRow("Vitamin A", rekamMedis['vitaminA']),
        ],
      ),
    );
  }

  // --- WIDGET BANTUAN UNTUK ROW DATA ---
  Widget _buildDataRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(
            value?.toString() ?? '-',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
