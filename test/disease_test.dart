import 'package:flutter_test/flutter_test.dart';
import 'package:vineguard_ai/src/core/domain/disease.dart';
import 'package:vineguard_ai/src/features/scan/domain/scan_result.dart';

void main() {
  test('all production classifier labels have care guidance', () {
    expect(diseaseProfiles.keys, containsAll(['Black_rot', 'Esca_(Black_Measles)', 'Leaf_blight_(Isariopsis_Leaf_Spot)', 'healthy']));
  });
  test('severity communicates prediction confidence', () {
    final result = ScanResult(label: 'healthy', confidence: .91, imagePath: 'leaf.jpg', createdAt: DateTime(2025));
    expect(result.severity, 'High confidence');
  });
}
