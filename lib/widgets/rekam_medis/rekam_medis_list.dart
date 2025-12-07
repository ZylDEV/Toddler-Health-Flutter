import 'package:flutter/material.dart';

class RekamMedisList extends StatelessWidget {
  final List<Map<String, dynamic>> rekamMedisList;
  final String searchQuery;
  final Function(Map<String, dynamic>) onTap;

  const RekamMedisList({
    super.key,
    required this.rekamMedisList,
    required this.searchQuery,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (rekamMedisList.isEmpty) {
      return const Center(
        child: Text(
          "Tidak ada data",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      );
    }

    // Filter list berdasarkan searchQuery (asumsi ini adalah fungsi dari searchQuery)
    final filteredList = rekamMedisList.where((rekam) {
      final name = rekam['namaBalita']?.toString().toLowerCase() ?? '';
      final query = searchQuery.toLowerCase();
      return name.contains(query);
    }).toList();
    
    final listToDisplay = searchQuery.isNotEmpty ? filteredList : rekamMedisList;

    if (listToDisplay.isEmpty && searchQuery.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Tidak ditemukan data untuk '$searchQuery'",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            "Riwayat Rekam Medis",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),

        SizedBox(
          height: 87, // PERUBAHAN: 88 - 1 = 87 pixels
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: listToDisplay.length,
            itemBuilder: (context, index) {
              final rekam = listToDisplay[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => onTap(rekam),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Colors.blueAccent.shade200,
                        width: 1.5,
                      ),
                    ),
                    elevation: 3,
                    shadowColor: Colors.blueAccent.withOpacity(0.2),
                    color: Colors.white,
                    child: Container(
                      width: 135, // Dibuat sedikit lebih sempit lagi
                      padding: const EdgeInsets.all(6), 
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 11, // Dibuat lebih kecil (dari 12)
                                backgroundColor: Colors.blueAccent,
                                child: Text(
                                  (rekam["namaBalita"] ?? "?")
                                      .toString()
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 9, // Dibuat lebih kecil (dari 10)
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  rekam['namaBalita'] ?? "-",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10, // Dibuat lebih kecil (dari 11)
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Tanggal",
                            style: TextStyle(
                              fontSize: 8, // Dibuat lebih kecil (dari 9)
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            rekam['tanggalPemeriksaan'] ?? "-",
                            style: const TextStyle(
                              fontSize: 10, // Dibuat lebih kecil (dari 11)
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 11, // PERUBAHAN: 12 - 1 = 11 pixels
                              color: Colors.blueAccent.shade200,
                            ),
                          )
                        ],
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