// lib/src/features/scanner/ui/scanner_screen.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:receipt_ocr/main.dart';
import '../data/mlkit_service.dart';
import '../logic/parser.dart';
import '../../edit_form/logic/receipt_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});
  @override
  ConsumerState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  late CameraController _ctrl;
  final _ml = MlKitService();
  bool _busy = false;
  bool _cameraOn = true; // toggle camera vs gallery

  /* ---------- LIFE-CYCLE ---------- */
  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _ctrl = CameraController(cameras[0], ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.nv21);
    await _ctrl.initialize();
    if (!mounted) return;
    setState(() {});
    _ctrl.startImageStream(_onCameraFrame);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  /* ---------- CAMERA STREAM ---------- */
  Future<void> _onCameraFrame(CameraImage img) async {
    if (_busy || !_cameraOn) return;
    _busy = true;
    final text = await _ml.scan(img, 90);
    if (text.length > 30) {
      _ctrl.stopImageStream();
      HapticFeedback.mediumImpact();
      _pushResult(text);
    }
    _busy = false;
  }

  /* ---------- GALLERY PICK ---------- */
  Future<void> _pickGallery() async {
    final status = await Permission.photos.request();
    if (!status.isGranted) return;
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    final text = await _ml.scanFromFile(bytes); // helper below
    _pushResult(text);
  }

  /* ---------- COMMON ROUTE ---------- */
  void _pushResult(String text) {
    final receipt = Parser.parse(text);
    ref.read(receiptProvider.notifier).state = receipt;
    Navigator.pushNamedAndRemoveUntil(context, '/detail', (route) => false);
  }

  /* ---------- UI ---------- */
  @override
  Widget build(BuildContext context) {
    if (!_ctrl.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_ctrl),
          CustomPaint(size: MediaQuery.sizeOf(context), painter: OverlayPainter()),
          // ===== BUTTONS INSIDE OVERLAY =====
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton.extended(
                    heroTag: 'gallery',
                    onPressed: _pickGallery,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                  FloatingActionButton.extended(
                    heroTag: 'camera',
                    onPressed: () {}, // dummy – live scan runs auto
                    icon: const Icon(Icons.camera),
                    label: Text(_cameraOn ? 'Scanning…' : 'Paused'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------- PAINTER ---------- */
class OverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width * 0.9;
    final h = w * 0.4;
    final r = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2), width: w, height: h);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = Colors.white;
    canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(12)), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}