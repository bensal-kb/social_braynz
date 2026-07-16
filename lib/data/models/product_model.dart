import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../core/constants/app_constants.dart';

class ProductModel extends Equatable {
  const ProductModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.lowStockThreshold = AppConstants.defaultLowStockThreshold,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final int quantity;
  final double price;
  final int lowStockThreshold;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isLowStock => quantity <= lowStockThreshold;

  factory ProductModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const {};
    return ProductModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      quantity: (data['quantity'] as num?)?.toInt() ?? 0,
      price: (data['price'] as num?)?.toDouble() ?? 0,
      lowStockThreshold:
          (data['lowStockThreshold'] as num?)?.toInt() ??
          AppConstants.defaultLowStockThreshold,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
    'price': price,
    'lowStockThreshold': lowStockThreshold,
    'createdAt': Timestamp.fromDate(createdAt ?? DateTime.now()),
    'updatedAt': Timestamp.fromDate(updatedAt ?? DateTime.now()),
  };

  ProductModel copyWith({
    String? name,
    int? quantity,
    double? price,
    int? lowStockThreshold,
  }) => ProductModel(
    id: id,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    price: price ?? this.price,
    lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
    createdAt: createdAt,
    updatedAt: DateTime.now(),
  );

  @override
  List<Object?> get props => [
    id,
    name,
    quantity,
    price,
    lowStockThreshold,
    createdAt,
    updatedAt,
  ];
}
