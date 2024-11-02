import 'package:earning_tracker/providers/earnings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TranscriptScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transcript = Provider.of<EarningsProvider>(context).transcript;

    return Scaffold(
      appBar: AppBar(title: Text('Earnings Transcript')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: transcript != null
            ? Text(transcript.content)
            : Center(child: Text('No transcript available')),
      ),
    );
  }
}
