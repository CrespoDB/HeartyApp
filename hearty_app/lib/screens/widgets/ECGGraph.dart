import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class ECGGraph extends StatefulWidget {
  final Stream<List<int>> dataStream;

  ECGGraph({Key? key, required this.dataStream}) : super(key: key);

  @override
  ECGGraphState createState() => ECGGraphState();
}

class ECGGraphState extends State<ECGGraph> {
  List<FlSpot> spots = [];
  double minY = -2; // Adjusted for ECG voltage range (in mV)
  double maxY = 2; // Adjusted for ECG voltage range (in mV)
  double intervalY = 0.5; // Y-axis interval for ECG voltage
  ScreenshotController screenshotController = ScreenshotController();
  StreamSubscription<List<int>>? _dataSubscription;
  int timeCounter = 0; // Time counter for the X-axis

  @override
  void initState() {
    super.initState();
    _dataSubscription = widget.dataStream.listen((data) {
      addData(data);
    });
  }

  void addData(List<int> data) {
    for (var value in data) {
      spots
          .add(FlSpot(timeCounter.toDouble(), value / 1000.0)); // Convert to mV
      timeCounter++;
    }
    if (mounted) setState(() {});
  }

  void clearGraph() {
    spots.clear();
    timeCounter = 0;
    if (mounted) setState(() {});
  }

  Future<void> saveGraphToCache() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await screenshotController
          .captureAndSave(directory.path, fileName: "ecg_graph.png");

      print("Graph saved to: $imagePath");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Graph saved to: $imagePath')));

      clearGraph();
    } catch (e) {
      print("Error saving graph: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error saving graph')));
    }
  }

  @override
  void dispose() {
    _dataSubscription
        ?.cancel(); // Cancel the subscription when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 20, // Adjust according to your time scale
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true, getTitlesWidget: _bottomTitleWidgets),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: intervalY,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text('${value.toStringAsFixed(1)} mV');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: Text('${(value / 40).toStringAsFixed(1)}s'),
    );
  }
}
