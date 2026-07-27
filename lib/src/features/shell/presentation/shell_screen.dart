import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/domain/disease.dart';
import '../../history/presentation/history_screen.dart';

class ShellScreen extends StatefulWidget { const ShellScreen({super.key}); @override State<ShellScreen> createState() => _ShellScreenState(); }
class _ShellScreenState extends State<ShellScreen> {
  var index = 0;
  @override Widget build(BuildContext context) {
    final screens = [Home(onScan: () => context.push('/camera')), const HistoryScreen(), const EncyclopediaScreen(), const SettingsScreen()];
    return Scaffold(body: SafeArea(child: screens[index]), bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: (value) => setState(() => index = value), destinations: const [NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'), NavigationDestination(icon: Icon(Icons.history), label: 'History'), NavigationDestination(icon: Icon(Icons.menu_book_outlined), label: 'Guide'), NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings')]));
  }
}
class Home extends StatelessWidget { const Home({super.key, required this.onScan}); final VoidCallback onScan; @override Widget build(BuildContext c) => Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('VineGuard AI', style: Theme.of(c).textTheme.headlineMedium), const SizedBox(height: 8), const Text('Offline grape leaf diagnosis'), const Spacer(), Card(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.shield_outlined, size: 48), const SizedBox(height: 16), Text('Ready to scan', style: Theme.of(c).textTheme.titleLarge), const SizedBox(height: 8), const Text('Use a clear, well-lit photo of one grape leaf. Analysis stays on this device.'), const SizedBox(height: 20), FilledButton.icon(onPressed: onScan, icon: const Icon(Icons.camera_alt), label: const Text('Scan a leaf'))]))])); }
class EncyclopediaScreen extends StatelessWidget { const EncyclopediaScreen({super.key}); @override Widget build(BuildContext c) => ListView(padding: const EdgeInsets.all(20), children: [Text('Disease guide', style: Theme.of(c).textTheme.headlineSmall), const SizedBox(height: 12), ...diseaseProfiles.values.map((d) => Card(child: ListTile(title: Text(d.title), subtitle: Text(d.description), onTap: () => showModalBottomSheet(context: c, showDragHandle: true, builder: (_) => Padding(padding: const EdgeInsets.all(24), child: SingleChildScrollView(child: Text('${d.title}\n\nSymptoms\n${d.symptoms}\n\nTreatment\n${d.treatment}\n\nPrevention\n${d.prevention}'))))))]); }
class SettingsScreen extends StatelessWidget { const SettingsScreen({super.key}); @override Widget build(BuildContext c) => ListView(padding: const EdgeInsets.all(20), children: [Text('Settings', style: Theme.of(c).textTheme.headlineSmall), const ListTile(leading: Icon(Icons.offline_bolt), title: Text('Offline operation'), subtitle: Text('Inference and scan history remain on your device.')), const ListTile(leading: Icon(Icons.info_outline), title: Text('Model information'), subtitle: Text('INT8 TensorFlow Lite model; crop advice should be checked with local agricultural guidance.'))]); }
