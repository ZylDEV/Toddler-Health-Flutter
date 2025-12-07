import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lottie/lottie.dart';
import '../widgets/rekam_medis/rekam_medis_search.dart';
import '../widgets/rekam_medis/rekam_medis_list.dart';
import '../widgets/rekam_medis/rekam_medis_detail.dart';
import '../widgets/rekam_medis/rekam_medis_chart.dart';

class RekamMedisPage extends StatefulWidget {
  final Map<String, String> userData;

  const RekamMedisPage({super.key, required this.userData});

  @override
  State<RekamMedisPage> createState() => _RekamMedisPageState();
}

// --- LANGKAH 1: Tambahkan 'with SingleTickerProviderStateMixin' ---
class _RekamMedisPageState extends State<RekamMedisPage>
    with SingleTickerProviderStateMixin {
  String searchQuery = "";
  bool loading = true;
  List<Map<String, dynamic>> riwayat = [];

  // --- LANGKAH 2: Buat TabController ---
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi TabController dengan 2 tab (Laki-laki & Perempuan)
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    // Jangan lupa hapus controller untuk menghindari memory leak
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    // Logika _loadData tetap sama, tidak perlu diubah
    final nikIbu = widget.userData['nikIbu'] ?? "";
    final dbRef = FirebaseDatabase.instance.ref();

    final balitaSnapshot = await dbRef.child('balita').get();
    final allBalitas = <Map<String, dynamic>>[];
    if (balitaSnapshot.exists) {
      final data = Map<String, dynamic>.from(balitaSnapshot.value as Map);
      data.forEach((key, value) {
        final b = Map<String, dynamic>.from(value);
        if (b['nikIbu'] == nikIbu) allBalitas.add(b..['id'] = key);
      });
    }

    final rekamSnapshot = await dbRef.child('rekamMedis').get();
    final allRekam = <Map<String, dynamic>>[];
    if (rekamSnapshot.exists) {
      final data = Map<String, dynamic>.from(rekamSnapshot.value as Map);
      data.forEach((key, value) {
        final r = Map<String, dynamic>.from(value);
        final balitaData = allBalitas.firstWhere(
          (b) => b['id'] == r['balitaId'],
          orElse: () => {},
        );
        if (balitaData.isNotEmpty) {
          allRekam.add({
            'id': key,
            'namaBalita': balitaData['nama'] ?? '-',
            'tanggalLahir': balitaData['tanggalLahir'] ?? '-',
            'jenisKelamin': balitaData['jenisKelamin'] ?? '-',
            'usia': r['usia'] ?? '-',
            'bb': r['bb'] ?? '-',
            'tj': r['tj'] ?? '-',
            'lk': r['lk'] ?? '-',
            'll': r['ll'] ?? '-',
            'vitaminA': r['vitaminA'] ?? '-',
            'tanggalPemeriksaan': r['tanggalPemeriksaan'] ?? '-',
          });
        }
      });
    }

    if (mounted) {
      setState(() {
        riwayat = allRekam;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = riwayat
        .where((r) =>
            r['namaBalita'].toString().toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    final dataLakiLaki = filteredData
        .where((r) => r['jenisKelamin'] == 'Laki-laki')
        .toList();

    final dataPerempuan = filteredData
        .where((r) => r['jenisKelamin'] == 'Perempuan')
        .toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            RekamMedisSearch(
              onChanged: (value) => setState(() => searchQuery = value),
            ),
            const SizedBox(height: 10),

            // --- LANGKAH 3: Ganti Blok Grafik dengan TabBar ---
            // Widget TabBar untuk tombolnya
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Laki-laki'),
                Tab(text: 'Perempuan'),
              ],
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            
            // Widget TabBarView untuk kontennya
            SizedBox(
              // Beri tinggi agar konten di dalamnya (grafik) terlihat
              height: 380, 
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Konten Tab 1: Grafik Laki-laki
                  (dataLakiLaki.isNotEmpty)
                      ? RekamMedisChart(
                          data: dataLakiLaki,
                          gender: Gender.male,
                        )
                      : const Center(
                          child: Text("Tidak ada data rekam medis anak laki-laki."),
                        ),

                  // Konten Tab 2: Grafik Perempuan
                  (dataPerempuan.isNotEmpty)
                      ? RekamMedisChart(
                          data: dataPerempuan,
                          gender: Gender.female,
                        )
                      : const Center(
                          child: Text("Tidak ada data rekam medis anak perempuan."),
                        ),
                ],
              ),
            ),
            // --- Akhir dari Blok TabBar ---

            const SizedBox(height: 10),

            // 🔹 List rekam medis (tidak perlu diubah)
            loading
                ? Center(
                    child: Lottie.asset(
                      'assets/loading.json',
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  )
                : RekamMedisList(
                    rekamMedisList: filteredData,
                    searchQuery: searchQuery,
                    onTap: (rekam) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RekamMedisDetail(rekamMedis: rekam),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}