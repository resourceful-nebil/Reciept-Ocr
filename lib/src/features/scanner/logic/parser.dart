// lib/src/features/scanner/logic/parser.dart
import 'package:intl/intl.dart';
import 'package:receipt_ocr/src/core/models.dart';

class Parser {
  static Receipt parse(String raw) {
    final store = RegExp(r'^([A-Za-z ].+)$', multiLine: true).firstMatch(raw)?.group(1)?.trim() ?? '';
    final dateM = RegExp(r'(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})').firstMatch(raw);
    String date = '';
    if (dateM != null) {
      try {
        date = DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(dateM.group(1)!));
      } catch (_) {}
    }
    double total = 0;
    final totalM = RegExp(r'(TOTAL|Grand Total|ብር)\s*[:]*\s*([0-9,.]+)', caseSensitive: false)
        .allMatches(raw);
    for (final m in totalM) {
      total = double.tryParse(m.group(2)!.replaceAll(',', '')) ?? total;
    }
    final conf = <String, double>{
      'storeName': store.isEmpty ? 0.4 : 0.8,
      'purchaseDate': date.isEmpty ? 0.3 : 0.9,
      'totalAmount': total == 0 ? 0.2 : 0.95,
    };
    return Receipt(
      storeName: store,
      purchaseDate: date,
      totalAmount: total,
      items: [],
      confidence: conf,
    );
  }
}