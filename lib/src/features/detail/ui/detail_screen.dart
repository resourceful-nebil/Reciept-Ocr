// lib/src/features/detail/ui/detail_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/models.dart';
import '../../../core/constants.dart';
import '../../edit_form/logic/receipt_provider.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = ref.watch(receiptProvider)!;
    final pretty = const JsonEncoder.withIndent('  ').convert(r.toJson());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parsed Receipt'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final xFile = XFile.fromData(Uint8List.fromList(utf8.encode(pretty)),
                  name: 'receipt.json', mimeType: 'application/json');
              Share.shareXFiles([xFile], text: 'My receipt JSON');
            },
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: pretty));
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Copied')));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      _row('Store', r.storeName, r.confidence['storeName']!),
                      _row('Date', r.purchaseDate, r.confidence['purchaseDate']!),
                      _row('Total', '${r.totalAmount} ETB', r.confidence['totalAmount']!),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Raw JSON', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SelectableText(pretty),
              ),
              const SizedBox(height: 24),
              Center(
                child: FilledButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/send'),
                  icon: const Icon(Icons.send),
                  label: const Text('Send to Backend'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String val, double conf) => ListTile(
        title: Text(val),
        subtitle: Text(label),
        trailing: Chip(
          label: Text('${(conf * 100).toStringAsFixed(0)} %'),
          backgroundColor: conf > 0.8 ? Colors.green : Colors.orange,
        ),
      );
}