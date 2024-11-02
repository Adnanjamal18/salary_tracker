class EarningsData {
  final String priceDate;
  final double actualEps;
  final double estimatedEps;
  final int actualRevenue;
  final int estimatedRevenue;

  EarningsData({
    required this.priceDate,
    required this.actualEps,
    required this.estimatedEps,
    required this.actualRevenue,
    required this.estimatedRevenue,
  });
}

class Transcript {
  final String content;

  Transcript({required this.content});
}
