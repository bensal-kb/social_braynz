import '../models/product_model.dart';

abstract class ProductRepo {
  /// All products ordered by name. Emits instantly from the local cache
  /// (works offline) and again whenever the cache or server updates.
  Stream<List<ProductModel>> watchProducts();

  /// Whether the most recent [watchProducts] emission came purely from the
  /// local cache (i.e. not yet confirmed by the server) — drives the
  /// "offline / showing cached data" banner.
  Stream<bool> watchIsFromCache();

  Stream<ProductModel?> watchProduct(String id);

  Future<ProductModel?> getProduct(String id);

  /// Client-generated Firestore document ID — works fully offline, no
  /// network round trip required.
  String newId();

  Future<void> addProduct(ProductModel product);

  Future<void> updateProduct(ProductModel product);

  Future<void> deleteProduct(String id);
}
