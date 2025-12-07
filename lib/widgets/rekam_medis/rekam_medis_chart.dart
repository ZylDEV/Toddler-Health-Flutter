import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

// ENUM to define the gender for clarity and type-safety
enum Gender { male, female }

// Data WHO BB/Usia (Male & Female)
// Usia dalam Tahun Pecahan (X) vs. Berat Badan (Y) dalam kg
class WhoGrowthData {
  // --- DATA LAKI-LAKI (MALE) ---
  static const List<FlSpot> male_plus3SD = [FlSpot(0.0, 4.8), FlSpot(0.5, 7.9), FlSpot(1.0, 10.7), FlSpot(2.0, 14.8), FlSpot(3.0, 18.7), FlSpot(4.0, 22.0), FlSpot(5.0, 25.4)];
  static const List<FlSpot> male_plus2SD = [FlSpot(0.0, 4.4), FlSpot(0.5, 7.3), FlSpot(1.0, 10.0), FlSpot(2.0, 13.9), FlSpot(3.0, 17.5), FlSpot(4.0, 20.8), FlSpot(5.0, 24.0)];
  static const List<FlSpot> male_median = [FlSpot(0.0, 3.2), FlSpot(0.5, 5.4), FlSpot(1.0, 7.5), FlSpot(2.0, 10.3), FlSpot(3.0, 12.8), FlSpot(4.0, 14.9), FlSpot(5.0, 16.9)];
  static const List<FlSpot> male_minus2SD = [FlSpot(0.0, 2.3), FlSpot(0.5, 3.8), FlSpot(1.0, 5.8), FlSpot(2.0, 8.9), FlSpot(3.0, 10.9), FlSpot(4.0, 12.5), FlSpot(5.0, 13.9)];
  static const List<FlSpot> male_minus3SD = [FlSpot(0.0, 2.0), FlSpot(0.5, 3.4), FlSpot(1.0, 5.2), FlSpot(2.0, 8.2), FlSpot(3.0, 10.1), FlSpot(4.0, 11.6), FlSpot(5.0, 12.9)];

  // --- DATA PEREMPUAN (FEMALE) ---
  static const List<FlSpot> female_plus3SD = [FlSpot(0.0, 4.6), FlSpot(0.5, 7.5), FlSpot(1.0, 10.2), FlSpot(2.0, 14.3), FlSpot(3.0, 18.2), FlSpot(4.0, 21.8), FlSpot(5.0, 25.5)];
  static const List<FlSpot> female_plus2SD = [FlSpot(0.0, 4.2), FlSpot(0.5, 6.9), FlSpot(1.0, 9.5), FlSpot(2.0, 13.3), FlSpot(3.0, 17.0), FlSpot(4.0, 20.3), FlSpot(5.0, 23.8)];
  static const List<FlSpot> female_median = [FlSpot(0.0, 3.0), FlSpot(0.5, 5.0), FlSpot(1.0, 7.0), FlSpot(2.0, 9.8), FlSpot(3.0, 12.2), FlSpot(4.0, 14.3), FlSpot(5.0, 16.3)];
  static const List<FlSpot> female_minus2SD = [FlSpot(0.0, 2.2), FlSpot(0.5, 3.5), FlSpot(1.0, 5.4), FlSpot(2.0, 8.3), FlSpot(3.0, 10.4), FlSpot(4.0, 12.0), FlSpot(5.0, 13.4)];
  static const List<FlSpot> female_minus3SD = [FlSpot(0.0, 2.0), FlSpot(0.5, 3.2), FlSpot(1.0, 4.9), FlSpot(2.0, 7.7), FlSpot(3.0, 9.6), FlSpot(4.0, 11.2), FlSpot(5.0, 12.4)];


  static double? getYValueAtX(List<FlSpot> data, double x) {
    if (data.isEmpty) return null;
    if (x <= data.first.x) return data.first.y;
    if (x >= data.last.x) return data.last.y;

    for (int i = 0; i < data.length - 1; i++) {
      final p1 = data[i];
      final p2 = data[i + 1];

      if (x >= p1.x && x <= p2.x) {
        if (p2.x == p1.x) return p1.y;
        final m = (p2.y - p1.y) / (p2.x - p1.x);
        return p1.y + m * (x - p1.x);
      }
    }
    return null;
  }

  // UPDATED: Now requires a gender to select the correct reference data
  static String getStatus(double usia, double bb, Gender gender) {
    final List<FlSpot> plus2SD = (gender == Gender.male) ? male_plus2SD : female_plus2SD;
    final List<FlSpot> minus2SD = (gender == Gender.male) ? male_minus2SD : female_minus2SD;

    final plus2 = getYValueAtX(plus2SD, usia);
    final minus2 = getYValueAtX(minus2SD, usia);

    if (plus2 == null || minus2 == null) {
      return 'N/A (Data WHO)';
    }

    if (bb > plus2) {
      return 'LEBIH'; // > +2 SD
    } else if (bb < minus2) {
      return 'KURANG'; // < -2 SD
    } else {
      return 'BAIK'; // antara -2 SD dan +2 SD
    }
  }
}

// ---

class RekamMedisChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final Gender gender; // ADDED: Gender parameter is now required

  const RekamMedisChart({super.key, required this.data, required this.gender});

  double _parseUsia(String usia) {
    final thnReg = RegExp(r'(\d+)\s*th');
    final blnReg = RegExp(r'(\d+)\s*bln');
    final thn = int.tryParse(thnReg.firstMatch(usia)?.group(1) ?? '0') ?? 0;
    final bln = int.tryParse(blnReg.firstMatch(usia)?.group(1) ?? '0') ?? 0;
    return thn + bln / 12.0;
  }

  LineChartBarData _buildWhoLine(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: false,
      color: color,
      barWidth: 1.5,
      dotData: const FlDotData(show: false),
      dashArray: [5, 5],
      shadow: Shadow(color: color.withOpacity(0.5), blurRadius: 4),
    );
  }

  LineChartBarData _buildShadedArea(List<FlSpot> topSpots, List<FlSpot> bottomSpots, Color color) {
    final List<FlSpot> combinedSpots = [
      ...topSpots,
      ...bottomSpots.reversed.map((s) => FlSpot(s.x, s.y)),
    ];
    return LineChartBarData(
      spots: combinedSpots,
      isCurved: false,
      color: Colors.transparent,
      barWidth: 0,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(0.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Text("Belum ada data rekam medis");
    }

    // --- NEW: Select WHO data based on gender ---
    final selectedPlus3SD = gender == Gender.male ? WhoGrowthData.male_plus3SD : WhoGrowthData.female_plus3SD;
    final selectedPlus2SD = gender == Gender.male ? WhoGrowthData.male_plus2SD : WhoGrowthData.female_plus2SD;
    final selectedMedian = gender == Gender.male ? WhoGrowthData.male_median : WhoGrowthData.female_median;
    final selectedMinus2SD = gender == Gender.male ? WhoGrowthData.male_minus2SD : WhoGrowthData.female_minus2SD;
    final selectedMinus3SD = gender == Gender.male ? WhoGrowthData.male_minus3SD : WhoGrowthData.female_minus3SD;
    // ---

    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var item in data) {
      final nama = item['namaBalita'] ?? 'Unknown';
      grouped.putIfAbsent(nama, () => []);
      grouped[nama]!.add(item);
    }

    final babyLineColors = [Colors.blue.shade700, Colors.deepPurple.shade700, Colors.teal.shade700, Colors.orange.shade700, Colors.pink.shade700, Colors.brown.shade700];
    int colorIndex = 0;
    List<LineChartBarData> allLines = [];
    List<_Legend> legends = [];

    double minX = 0;
    double maxX = 5.0;
    double minY = double.maxFinite;
    double maxY = double.negativeInfinity;

    // --- Garis dan Area Referensi WHO (using selected data) ---
    allLines.add(_buildShadedArea(selectedMinus2SD, selectedMinus3SD, Colors.yellow));
    allLines.add(_buildShadedArea(selectedPlus2SD, selectedMinus2SD, Colors.green));
    allLines.add(_buildShadedArea(selectedPlus3SD, selectedPlus2SD, Colors.red));

    allLines.add(LineChartBarData(
      spots: selectedMedian,
      isCurved: false,
      color: Colors.blueGrey.shade800,
      barWidth: 2,
      dotData: const FlDotData(show: false),
    ));

    allLines.add(_buildWhoLine(selectedPlus2SD, Colors.black54));
    allLines.add(_buildWhoLine(selectedMinus2SD, Colors.black54));

    for (var spot in selectedPlus3SD) { maxY = max(maxY, spot.y); }
    for (var spot in selectedMinus3SD) { minY = min(minY, spot.y); }

    legends.add(const _Legend(color: Colors.blueGrey, text: "Median", isWHO: true));
    legends.add(const _Legend(color: Colors.black54, text: "+2/-2 SD (Garis Batas)", isWHO: true, isDashed: true));
    legends.add(const _Legend(color: Colors.yellow, text: "Area Kurang Gizi", isWHO: true, isBox: true));
    legends.add(const _Legend(color: Colors.green, text: "Area Normal", isWHO: true, isBox: true));
    legends.add(const _Legend(color: Colors.red, text: "Area Gizi Lebih", isWHO: true, isBox: true));

    // --- Data Balita ---
    grouped.forEach((nama, records) {
      final color = babyLineColors[colorIndex % babyLineColors.length];
      colorIndex++;

      records.sort((a, b) {
        final ua = a['usia'] ?? '';
        final ub = b['usia'] ?? '';
        return _parseUsia(ua).compareTo(_parseUsia(ub));
      });

      List<FlSpot> spots = [];
      String statusGizi = 'N/A';

      for (var r in records) {
        final usiaStr = r['usia'] ?? '';
        final bbStr = r['bb']?.toString() ?? '';
        final x = _parseUsia(usiaStr);
        final y = double.tryParse(bbStr);

        if (y != null) {
          spots.add(FlSpot(x, y));
          maxX = max(maxX, x);
          minY = min(minY, y);
          maxY = max(maxY, y);

          if (r == records.last) {
            // UPDATED: Pass gender to getStatus
            statusGizi = WhoGrowthData.getStatus(x, y, gender);
          }
        }
      }

      if (spots.isNotEmpty) {
        allLines.add(LineChartBarData(
          spots: spots,
          isCurved: true,
          color: color,
          barWidth: 3,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
              radius: 4,
              color: color,
              strokeWidth: 1.5,
              strokeColor: Colors.white,
            ),
          ),
          shadow: const Shadow(color: Colors.black38, blurRadius: 4),
        ));

        legends.add(_Legend(
          color: color,
          text: '$nama',
          isWHO: false,
          status: statusGizi,
        ));
      }
    });

    // ... (The rest of your axis adjustment and UI build code remains the same)
    
     // 2. Logika Penyesuaian Batas Sumbu 
    final rangeY = maxY - minY;
    
    minX = 0; 
    maxX = max(5.0, maxX + 0.5); 
    final double intervalX = 0.5; 
    
    // Penyesuaian Sumbu Y (Berat Badan)
    final double paddingY = rangeY > 0 ? rangeY * 0.1 : 1.0;
    minY = max(0, minY - paddingY);
    maxY = maxY + paddingY;

    double intervalY;
    if (rangeY <= 1.0) { intervalY = 0.5; } 
    else if (rangeY <= 3.0) { intervalY = 1.0; } 
    else if (rangeY <= 6.0) { intervalY = 2.0; } 
    else { intervalY = 5.0; }
    
    minY = (minY / intervalY).floor() * intervalY;
    maxY = (maxY / intervalY).ceil() * intervalY;
    
    if (maxY - minY < intervalY * 2) {
      maxY = minY + intervalY * 2;
    }
    
    // 3. Bangun Widget Grafik
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "Grafik Pertumbuhan (${gender == Gender.male ? 'Laki-laki' : 'Perempuan'})", // Title updated
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.blueAccent.shade200, width: 2),
            ),
            elevation: 8,
            shadowColor: Colors.blueAccent.withOpacity(0.5),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200, 
                    child: LineChart(
                      LineChartData(
                        minX: minX,
                        maxX: maxX,
                        minY: minY,
                        maxY: maxY,
                        lineBarsData: allLines,
                        
                        gridData: FlGridData(
                          show: true,
                          horizontalInterval: intervalY,
                          verticalInterval: intervalX,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.grey.withOpacity(0.2), 
                            strokeWidth: 1,
                          ),
                          getDrawingVerticalLine: (value) => FlLine(
                            color: Colors.grey.withOpacity(0.2), 
                            strokeWidth: 1,
                          ),
                        ),
                        
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          
                          leftTitles: AxisTitles(
                            axisNameWidget: const Text("BB (kg)", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87)),
                            axisNameSize: 20,
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: intervalY, 
                              reservedSize: 50, 
                              getTitlesWidget: (value, meta) {
                                final isLabelValue = (value - meta.min).abs() % intervalY < 0.001;
                                if (!isLabelValue) return const SizedBox.shrink(); 
                                
                                final label = intervalY < 1.0 
                                  ? value.toStringAsFixed(1) 
                                  : value.toInt().toString();
                                  
                                return Text(label, style: const TextStyle(fontSize: 10, color: Colors.black87));
                              },
                            ),
                          ),
                          
                          bottomTitles: AxisTitles(
                            axisNameWidget: const Text("Usia (th)", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87)),
                            axisNameSize: 20,
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: intervalX, 
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                final isLabelValue = (value - meta.min).abs() % intervalX < 0.001;
                                if (!isLabelValue) return const SizedBox.shrink(); 
                                
                                final label = (value % 1 == 0) 
                                  ? '${value.toInt()} th'
                                  : value.toStringAsFixed(1);
                                
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(label, style: const TextStyle(fontSize: 10, color: Colors.black87)),
                                );
                              },
                            ),
                          ),
                        ),
                        
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: Colors.black87, width: 1.5),
                        ),
                        
                        lineTouchData: const LineTouchData(
                          enabled: true, 
                          touchTooltipData: LineTouchTooltipData(), 
                        ), 
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Legenda
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: legends,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// _Legend widget remains unchanged
class _Legend extends StatelessWidget {
  final Color color;
  final String text;
  final bool isWHO;
  final String status;
  final bool isDashed;
  final bool isBox;

  const _Legend({required this.color, required this.text, required this.isWHO, this.status = '', this.isDashed = false, this.isBox = false});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Widget indicator;

    if (!isWHO) {
      if (status == 'KURANG') {
        textColor = Colors.orange.shade800;
      } else if (status == 'LEBIH') {
        textColor = Colors.red.shade800;
      } else {
        textColor = Colors.black87;
      }
      
      indicator = Container(width: 10, height: 2, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)));
      
      final balitaText = Text('$text (${status.toUpperCase()})', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor));
      return Row(mainAxisSize: MainAxisSize.min, children: [indicator, const SizedBox(width: 4), balitaText]);

    } else {
      textColor = Colors.grey.shade700;
      
      if (isBox) {
          indicator = Container(
            width: 10, 
            height: 10,
            decoration: BoxDecoration(
              color: color.withOpacity(0.25), 
              border: Border.all(color: color.withOpacity(0.9), width: 1),
            ),
          );
      } else if (isDashed) {
        indicator = Row(
          children: List.generate(3, (index) => Container(
            width: 3, 
            height: 1.5, 
            margin: const EdgeInsets.symmetric(horizontal: 0.5),
            color: color,
          )),
        );
      } else {
        indicator = Container(width: 10, height: 2, color: color);
      }
      
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: textColor)),
        ],
      );
    }
  }
}