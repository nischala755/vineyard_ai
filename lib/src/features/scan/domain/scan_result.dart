class ScanResult {
  const ScanResult(
      {required this.label,
      required this.confidence,
      required this.imagePath,
      required this.createdAt});
  final String label, imagePath;
  final double confidence;
  final DateTime createdAt;
  String get severity => confidence < .65
      ? 'Low confidence'
      : confidence < .85
          ? 'Moderate confidence'
          : 'High confidence';
}
