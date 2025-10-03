// lib/src/features/scanner/data/mlkit_service.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class MlKitService {
  final _rec = TextRecognizer();
  Future<String> scan(CameraImage img, int rot) async {
    final w = img.width;
    final h = img.height;
    final input = InputImage.fromBytes(
      bytes: _concatPlanes(img.planes),
      metadata: InputImageMetadata(
        size: Size(w.toDouble(), h.toDouble()),
        rotation: InputImageRotationValue.fromRawValue(rot) ?? InputImageRotation.rotation0deg,
        format: InputImageFormat.nv21,
        bytesPerRow: img.planes[0].bytesPerRow,
      ),
    );
    final res = await _rec.processImage(input);
    return res.text;
  }

  Uint8List _concatPlanes(List<Plane> planes) {
    final w = planes[0].bytesPerRow;
    final h = planes[0].height;
    final buf = Uint8List((w * h! * 1.5).toInt());
    int o = 0;
    for (final p in planes) {
      buf.setRange(o, o + p.bytes.length, p.bytes);
      o += p.bytes.length;
    }
    return buf;
  }

  Future<String> scanFromFile(Uint8List bytes) async {
  final temp = File('${(await getTemporaryDirectory()).path}/temp.jpg');
  await temp.writeAsBytes(bytes);
  final input = InputImage.fromFile(temp);
  final res = await _rec.processImage(input);
  await temp.delete(); // clean up
  return res.text;
}
}