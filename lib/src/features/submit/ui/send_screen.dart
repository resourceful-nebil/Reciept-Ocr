// lib/src/features/submit/ui/send_screen.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants.dart';
import '../../edit_form/logic/receipt_provider.dart';

class SendScreen extends ConsumerStatefulWidget {
  const SendScreen({super.key});
  @override
  ConsumerState createState() => _SendScreenState();
}

class _SendScreenState extends ConsumerState<SendScreen> {
  bool _sending = false;
  bool _done = false;

  Future<void> _submit() async {
    setState(() => _sending = true);
    try {
      final dio = Dio()..options.headers['Authorization'] = K.authToken;
      final r = ref.read(receiptProvider)!;
      final res = await dio.post('${K.baseUrl}/receipts', data: r.toJson());
      if (!mounted) return;
      setState(() => _done = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ $e')));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_done)
              Lottie.asset('assets/success.json', width: 120, height: 120, repeat: false),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _sending || _done ? null : _submit,
              icon: _sending ? const SizedBox() : const Icon(Icons.cloud_upload),
              label: _sending
                  ? const CircularProgressIndicator()
                  : Text(_done ? 'Accepted' : 'POST to Backend'),
            ),
          ],
        ),
      ),
    );
  }
}