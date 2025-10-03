// lib/src/core/models.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'models.freezed.dart';
part 'models.g.dart';

@freezed
class Receipt with _$Receipt {
  const factory Receipt({
    required String storeName,
    required String purchaseDate,
    required double totalAmount,
    required List<Item> items,
    required Map<String, double> confidence,
  }) = _Receipt;
  factory Receipt.fromJson(Map<String, dynamic> j) => _$ReceiptFromJson(j);
}

@freezed
class Item with _$Item {
  const factory Item({
    required String name,
    int? quantity,
    double? unitPrice,
    double? lineTotal,
  }) = _Item;
  factory Item.fromJson(Map<String, dynamic> j) => _$ItemFromJson(j);
}
