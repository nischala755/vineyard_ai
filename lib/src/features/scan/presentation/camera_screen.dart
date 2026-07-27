import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget { const CameraScreen({super.key}); @override State<CameraScreen> createState() => _CameraScreenState(); }
class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  CameraController? controller;
  String? error;
  @override void initState() { super.initState(); WidgetsBinding.instance.addObserver(this); _start(); }
  Future<void> _start() async {
    if (!await Permission.camera.request().isGranted) { setState(() => error = 'Camera permission is required to scan a leaf.'); return; }
    try { final cameras = await availableCameras(); final camera = cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.back, orElse: () => cameras.first); controller = CameraController(camera, ResolutionPreset.medium, enableAudio: false); await controller!.initialize(); if (mounted) setState(() {}); } catch (_) { if (mounted) setState(() => error = 'The camera could not be started.'); }
  }
  Future<void> _capture() async { final c = controller; if (c == null || c.value.isTakingPicture) return; final photo = await c.takePicture(); if (mounted) context.go('/prediction', extra: photo.path); }
  Future<void> _gallery() async { final photo = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 95); if (photo != null && mounted) context.go('/prediction', extra: photo.path); }
  @override void dispose() { WidgetsBinding.instance.removeObserver(this); controller?.dispose(); super.dispose(); }
  @override Widget build(BuildContext c) => Scaffold(appBar: AppBar(title: const Text('Scan a grape leaf')), body: error != null ? Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(error!, textAlign: TextAlign.center))) : controller?.value.isInitialized != true ? const Center(child: CircularProgressIndicator()) : Stack(fit: StackFit.expand, children: [CameraPreview(controller!), Center(child: Container(width: 260, height: 260, decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 3), borderRadius: BorderRadius.circular(24)))), Align(alignment: Alignment.bottomCenter, child: SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [IconButton.filledTonal(onPressed: _gallery, icon: const Icon(Icons.photo_library), tooltip: 'Choose from gallery'), FloatingActionButton.large(onPressed: _capture, child: const Icon(Icons.camera_alt))])))]));
}
