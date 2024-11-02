import 'dart:convert';
import 'package:earning_tracker/modals/models.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EarningsProvider with ChangeNotifier {
  List<EarningsData> _earningsData = [];
  Transcript? _transcript;
  bool isLoading = false;

  List<EarningsData> get earningsData => _earningsData;
  Transcript? get transcript => _transcript;

  Future<void> fetchEarnings(String ticker) async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse('https://api.api-ninjas.com/v1/earningscalendar?ticker=$ticker');
    try {
      final response = await http.get(
        url,
        headers: {'X-Api-Key': 'C8iOWvhZ8oQx02o6tnVBKg==6IWsxPALBdBDx3Vz'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _earningsData = data.map((item) {
          return EarningsData(
            priceDate: item['pricedate'] ?? '',
            actualEps: (item['actual_eps'] as num?)?.toDouble() ?? 0.0,
            estimatedEps: (item['estimated_eps'] as num?)?.toDouble() ?? 0.0,
            actualRevenue: item['actual_revenue'] ?? 0,
            estimatedRevenue: item['estimated_revenue'] ?? 0,
          );
        }).toList();
      } else {
        print("Failed to load earnings data: ${response.statusCode} - ${response.body}");
      }
    } catch (error) {
      print("Error fetching earnings data: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTranscript(String ticker, String priceDate) async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.api-ninjas.com/v1/earningstranscript?ticker=$ticker&date=$priceDate');
    final response = await http.get(
      url,
      headers: {'X-Api-Key': 'C8iOWvhZ8oQx02o6tnVBKg==6IWsxPALBdBDx3Vz'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _transcript = Transcript(content: data['transcript']);
    } else {
      print("Failed to load transcript: ${response.statusCode} - ${response.body}");
    }
    isLoading = false;
    notifyListeners();
  }
}
