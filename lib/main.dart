// lib/main.dart
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/theme.dart';
import 'src/features/backend/embedded_server.dart';
import 'src/features/scanner/ui/scanner_screen.dart';
import 'src/features/detail/ui/detail_screen.dart';
import 'src/features/submit/ui/send_screen.dart';

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await EmbeddedServer.start();       // <-- server inside APK
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Receipt OCR',
      theme: appTheme,
      initialRoute: '/',
      routes: {
        '/': (_) => const ScannerScreen(),
        '/detail': (_) => const DetailScreen(),
        '/send': (_) => const SendScreen(),
      },
    );
  }
}