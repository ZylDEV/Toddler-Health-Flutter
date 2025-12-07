import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../widgets/jadwal/jadwal_search.dart';
import '../widgets/jadwal/jadwal_list.dart';

class JadwalPage extends StatefulWidget {
  final Map<String, String> userData;

  const JadwalPage({super.key, required this.userData});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  String searchQuery = "";
  bool loading = true;
  List<Map<String, String>> jadwalList = [];

  @override
  void initState() {
    super.initState();
    loadJadwal();
  }

  Future<void> loadJadwal() async {
    setState(() => loading = true);
    final dbRef = FirebaseDatabase.instance.ref();

    try {
      final snapshot = await dbRef.child('jadwal').get();
      final List<Map<String, String>> tempList = [];

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        data.forEach((key, value) {
          final item = Map<String, dynamic>.from(value);
          tempList.add({
            "tanggal": item['tanggalPelaksanaan'] ?? '-',
            "waktu": item['waktuPelaksanaan'] ?? '-',
            "lokasi": item['lokasi'] ?? '-',
            "deskripsi": item['deskripsiKegiatan'] ?? '-',
          });
        });
      }

      setState(() {
        jadwalList = tempList;
        loading = false;
      });
    } catch (e) {
      print("Error loading jadwal: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    final filtered = jadwalList.where((jadwal) {
      final query = searchQuery.toLowerCase();
      return jadwal["deskripsi"]!.toLowerCase().contains(query) ||
          jadwal["lokasi"]!.toLowerCase().contains(query) ||
          jadwal["tanggal"]!.toLowerCase().contains(query);
    }).toList();

    return Column(
      children: [
        const SizedBox(height: 8), // biar sama kaya di imunisasi
        JadwalSearch(
          onChanged: (val) {
            setState(() => searchQuery = val);
          },
        ),
        Expanded(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : JadwalList(jadwalList: filtered),
        ),
      ],
    );
  }
}
