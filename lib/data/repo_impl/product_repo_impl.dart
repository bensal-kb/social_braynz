import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/fire_and_forget.dart';
import '../models/product_model.dart';
import '../repo/product_repo.dart';

class ProductRepoImpl implements ProductRepo {
  ProductRepoImpl(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection(AppConstants.productsCollection);

  @override
  Stream<List<ProductModel>> watchProducts() => _products
      .orderBy('name')
      .snapshots(includeMetadataChanges: true)
      .map((snap) => snap.docs.map(ProductModel.fromDoc).toList());

  @override
  Stream<bool> watchIsFromCache() => _products
      .orderBy('name')
      .snapshots(includeMetadataChanges: true)
      .map((snap) => snap.metadata.isFromCache);

  @override
  Stream<ProductModel?> watchProduct(String id) => _products
      .doc(id)
      .snapshots(includeMetadataChanges: true)
      .map((doc) => doc.exists ? ProductModel.fromDoc(doc) : null);

  @override
  Future<ProductModel?> getProduct(String id) async {
    final ref = _products.doc(id);
    // Cache-first: a default get() asks the server first and hangs on a
    // dead/half-open connection instead of falling back, blocking screens
    // that prefill from this read. The cache is effectively always warm
    // here (the product was just rendered in a list to be tapped on).
    try {
      final cached = await ref.get(const GetOptions(source: Source.cache));
      if (cached.exists) return ProductModel.fromDoc(cached);
    } on FirebaseException {
      // Not in cache — fall through to the server read.
    }
    final doc = await ref.get();
    return doc.exists ? ProductModel.fromDoc(doc) : null;
  }

  @override
  String newId() => _products.doc().id;

  @override
  Future<void> addProduct(ProductModel product) async {
    fireAndForget(
      _products.doc(product.id).set(product.toJson()),
      label: 'addProduct(${product.id})',
    );
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    fireAndForget(
      _products.doc(product.id).update(product.toJson()),
      label: 'updateProduct(${product.id})',
    );
  }

  @override
  Future<void> deleteProduct(String id) async {
    fireAndForget(_products.doc(id).delete(), label: 'deleteProduct($id)');
  }
}
