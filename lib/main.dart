import 'package:earning_tracker/providers/earnings_provider.dart';
import 'package:earning_tracker/screens/transcript_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => EarningsProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Earnings Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: EarningsScreen(),
    );
  }
}

class EarningsScreen extends StatefulWidget {
  @override
  _EarningsScreenState createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  final _tickerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EarningsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Earnings Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tickerController,
              decoration: InputDecoration(
                labelText: 'Enter Company Ticker (e.g., MSFT)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                provider.fetchEarnings(_tickerController.text.trim());
              },
              child: Text('Fetch Earnings Data'),
            ),
            SizedBox(height: 16),
            provider.isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: EarningsGraph(
                      ticker: _tickerController.text.trim(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class EarningsGraph extends StatelessWidget {
  final String ticker;

  EarningsGraph({required this.ticker});

  @override
  Widget build(BuildContext context) {
    final earningsData = Provider.of<EarningsProvider>(context).earningsData;

    if (earningsData.isEmpty) {
      return Center(child: Text('No data available'));
    }

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: earningsData
                .asMap()
                .entries
                .map((entry) => FlSpot(entry.key.toDouble(), entry.value.estimatedEps))
                .toList(),
            isCurved: true,
            color: Colors.blue,
            dotData: FlDotData(show: true),
          ),
          LineChartBarData(
            spots: earningsData
                .asMap()
                .entries
                .map((entry) => FlSpot(entry.key.toDouble(), entry.value.actualEps))
                .toList(),
            isCurved: true,
            color: Colors.green,
            dotData: FlDotData(show: true),
          ),
        ],
        lineTouchData: LineTouchData(
          touchCallback: (event, response) {
            if (response != null && response.lineBarSpots != null) {
              final index = response.lineBarSpots![0].spotIndex;
              final data = earningsData[index];
              final provider = Provider.of<EarningsProvider>(context, listen: false);

              // Fetch the transcript for the selected year and quarter
              provider.fetchTranscript(ticker, data.priceDate).then((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TranscriptScreen(),
                  ),
                );
              });
            }
          },
        ),
      ),
    );
  }
}
