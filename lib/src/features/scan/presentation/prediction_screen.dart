import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/domain/disease.dart';
import '../../history/data/history_repository.dart';
import '../data/tflite_classifier.dart';
import '../data/image_quality_gate.dart';
import '../domain/scan_result.dart';

final classifierProvider =
    FutureProvider<LeafClassifier>((_) => LeafClassifier.create());

class PredictionScreen extends ConsumerStatefulWidget {
  const PredictionScreen({super.key, required this.imagePath});
  final String imagePath;
  @override
  ConsumerState<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends ConsumerState<PredictionScreen> {
  Future<ScanResult>? prediction;
  @override
  void initState() {
    super.initState();
    final qualityError = ImageQualityGate.validate(widget.imagePath);
    prediction = qualityError == null
        ? ref.read(classifierProvider.future).then((model) {
            final result = model.classify(widget.imagePath);
            if (result.confidence < .65)
              throw StateError(
                  'This does not look like a clear, supported grape-leaf pattern. Retake the photo with one leaf filling the guide.');
            return result;
          })
        : Future<ScanResult>.error(qualityError);
  }

  @override
  Widget build(BuildContext c) => Scaffold(
      appBar: AppBar(title: const Text('Diagnosis')),
      body: FutureBuilder<ScanResult>(
          future: prediction,
          builder: (c, snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return const Center(child: CircularProgressIndicator());
            if (snapshot.hasError)
              return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                      child: Text(
                          'The on-device model is unavailable or this photo cannot be analysed.\n\n${snapshot.error}',
                          textAlign: TextAlign.center)));
            final scan = snapshot.requireData;
            final profile =
                diseaseProfiles[scan.label] ?? diseaseProfiles['healthy']!;
            _save(scan);
            return ListView(padding: const EdgeInsets.all(20), children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(File(widget.imagePath),
                      height: 220, fit: BoxFit.cover)),
              const SizedBox(height: 20),
              Text(profile.title, style: Theme.of(c).textTheme.headlineSmall),
              Text(
                  '${(scan.confidence * 100).toStringAsFixed(1)}% confidence • ${scan.severity}'),
              const Divider(height: 32),
              _section('Description', profile.description),
              _section('Symptoms', profile.symptoms),
              _section('Recommended treatment', profile.treatment),
              _section('Organic treatment', profile.organicTreatment),
              _section('Preventive measures', profile.prevention),
              _section('Recovery estimate', profile.recovery),
              const SizedBox(height: 16),
              const Text(
                  'This app supports field scouting and is not a substitute for local agricultural advice.',
                  style: TextStyle(fontStyle: FontStyle.italic))
            ]);
          }));
  bool saved = false;
  void _save(ScanResult scan) {
    if (!saved) {
      saved = true;
      HistoryRepository().save(scan);
    }
  }

  Widget _section(String title, String value) => Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(value)
      ]));
}
