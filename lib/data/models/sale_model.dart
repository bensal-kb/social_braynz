import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class SaleModel extends Equatable {
  const SaleModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantitySold,
    required this.unitPrice,
    required this.total,
    required this.timestamp,
  });

  final String id;
  final String productId;
  final String productName;
  final int quantitySold;
  final double unitPrice;
  final double total;
  final DateTime timestamp;

  factory SaleModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const {};
    return SaleModel(
      id: doc.id,
      productId: data['productId'] as String? ?? '',
      productName: data['productName'] as String? ?? '',
      quantitySold: (data['quantitySold'] as num?)?.toInt() ?? 0,
      unitPrice: (data['unitPrice'] as num?)?.toDouble() ?? 0,
      total: (data['total'] as num?)?.toDouble() ?? 0,
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'productName': productName,
    'quantitySold': quantitySold,
    'unitPrice': unitPrice,
    'total': total,
    // Client-set (not FieldValue.serverTimestamp()) so offline-created sales
    // display and sort correctly before the write reaches the server.
    'timestamp': Timestamp.fromDate(timestamp),
  };

  @override
  List<Object?> get props => [
    id,
    productId,
    productName,
    quantitySold,
    unitPrice,
    total,
    timestamp,
  ];
}
