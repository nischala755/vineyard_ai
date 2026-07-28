import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../scan/domain/scan_result.dart';

class HistoryRepository {
  Future<Database> get _database async => openDatabase(
      join(await getDatabasesPath(), 'vineguard.db'),
      version: 1,
      onCreate: (db, _) => db.execute(
          'CREATE TABLE scans(id INTEGER PRIMARY KEY AUTOINCREMENT, label TEXT NOT NULL, confidence REAL NOT NULL, image_path TEXT NOT NULL, created_at TEXT NOT NULL, notes TEXT NOT NULL DEFAULT \'\')'));
  Future<void> save(ScanResult scan) async =>
      (await _database).insert('scans', {
        'label': scan.label,
        'confidence': scan.confidence,
        'image_path': scan.imagePath,
        'created_at': scan.createdAt.toIso8601String()
      });
  Future<List<ScanResult>> all() async => (await _database)
      .query('scans', orderBy: 'created_at DESC')
      .then((rows) => rows
          .map((r) => ScanResult(
              label: r['label']! as String,
              confidence: r['confidence']! as double,
              imagePath: r['image_path']! as String,
              createdAt: DateTime.parse(r['created_at']! as String)))
          .toList());
}
