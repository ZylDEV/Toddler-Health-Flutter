import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lottie/lottie.dart';
import '../widgets/imunisasi/imunisasi_list.dart';
import '../widgets/imunisasi/imunisasi_search.dart';
import '../widgets/imunisasi/imunisasi_detail.dart';

class ImunisasiPage extends StatefulWidget {
  final Map<String, String> userData;

  const ImunisasiPage({super.key, required this.userData});

  @override
  State<ImunisasiPage> createState() => _ImunisasiPageState();
}

class _ImunisasiPageState extends State<ImunisasiPage> {
  String searchQuery = "";
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  List<Map<String, dynamic>> balitas = [];
  Map<String, Map<String, dynamic>> imunisasiData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    setState(() => isLoading = true);
    final nikIbu = widget.userData['nikIbu'] ?? "";
    balitas.clear();

    try {
      // Ambil data balita
      final balitaSnap = await dbRef.child("balita").get();
      if (balitaSnap.exists) {
        final Map balitaMap = balitaSnap.value as Map;
        balitaMap.forEach((key, value) {
          final Map<String, dynamic> balitaData = Map<String, dynamic>.from(value);
          balitaData['id'] = key;
          if (balitaData['nikIbu'] == nikIbu) {
            balitas.add(balitaData);
          }
        });
      }

      // Ambil data imunisasi
      final imunisasiSnap = await dbRef.child("imunisasi").get();
      if (imunisasiSnap.exists) {
        final Map imunMap = imunisasiSnap.value as Map;
        imunMap.forEach((key, value) {
          imunisasiData[key] = Map<String, dynamic>.from(value);
        });
      }
    } catch (e) {
      print("Error loading data: $e");
    }

    setState(() => isLoading = false);
  }

  void _onTapBalita(Map<String, dynamic> balita) {
    final balitaId = (balita['id'] ?? balita['balitaId'])?.toString().trim();
    if (balitaId == null || balitaId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: ID Balita tidak ditemukan pada data balita.")),
      );
      return;
    }

    final dataGabungan = imunisasiData.entries
        .firstWhere(
          (e) => e.value['balitaId']?.toString().trim() == balitaId,
          orElse: () => MapEntry('', {}),
        )
        .value;

    if (dataGabungan.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Riwayat imunisasi detail balita ini tidak ditemukan.")),
      );
      return;
    }

    // Pisahkan data balita dan imunisasi
    final detailBalita = {
      'nama': dataGabungan['namaBalita'] ?? balita['nama'],
      'jenisKelamin': dataGabungan['jenisKelamin'] ?? balita['jenisKelamin'],
      'tanggalLahir': dataGabungan['tanggalLahir'] ?? balita['tanggalLahir'],
    };

    final detailImunisasi = Map<String, dynamic>.from(dataGabungan)
      ..remove('namaBalita')
      ..remove('jenisKelamin')
      ..remove('tanggalLahir')
      ..remove('balitaId');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImunisasiDetail(
          balita: detailBalita,
          imunisasi: detailImunisasi,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Lottie.asset(
          'assets/loading.json',
          width: 150,
          height: 150,
          fit: BoxFit.contain,
        ),
      );
    }

    return Column(
      children: [
        // 🔹 Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
          child: ImunisasiSearch(
            onChanged: (value) => setState(() => searchQuery = value),
          ),
        ),

        // 🔹 List balita
        Expanded(
          child: ImunisasiList(
            balitas: balitas,
            searchQuery: searchQuery,
            onTapBalita: _onTapBalita,
          ),
        ),
      ],
    );
  }
}
