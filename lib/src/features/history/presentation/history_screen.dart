import 'dart:io';
import 'package:flutter/material.dart';
import '../data/history_repository.dart';
import '../../scan/domain/scan_result.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final repo = HistoryRepository();
  late Future<List<ScanResult>> scans = repo.all();
  @override
  Widget build(BuildContext c) => FutureBuilder<List<ScanResult>>(
      future: scans,
      builder: (c, snapshot) {
        final items = snapshot.data ?? <ScanResult>[];
        return ListView(padding: const EdgeInsets.all(20), children: [
          Text('Scan history', style: Theme.of(c).textTheme.headlineSmall),
          const SizedBox(height: 12),
          if (snapshot.connectionState == ConnectionState.waiting)
            const Center(
                child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator()))
          else if (items.isEmpty)
            const Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                    'No scans yet. Your saved diagnoses will appear here.'))
          else
            ...items.map<Widget>((s) => Card(
                child: ListTile(
                    leading: Image.file(File(s.imagePath),
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported)),
                    title: Text(s.label.replaceAll('_', ' ')),
                    subtitle: Text(
                        '${(s.confidence * 100).toStringAsFixed(0)}% • ${s.createdAt.toLocal()}'))))
        ]);
      });
}
