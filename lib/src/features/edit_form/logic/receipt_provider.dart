// lib/src/features/edit_form/logic/receipt_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models.dart';

final receiptProvider = StateProvider<Receipt?>((ref) => null);