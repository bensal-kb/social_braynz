import '../../../../core/base/base_bloc/base_states.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../data/models/product_model.dart';

class ProductListState extends BaseState {
  const ProductListState({
    super.state,
    super.error,
    this.products = const [],
    this.lowStockOnly = false,
    this.isFromCache = false,
    this.isOnline = true,
  });

  final List<ProductModel> products;
  final bool lowStockOnly;

  /// Whether Firestore's own listener is currently serving cached (not
  /// live-synced) data — the source of truth for "is this list stale."
  final bool isFromCache;

  /// Raw OS-reported connectivity, updated faster than [isFromCache] (see
  /// `ConnectivityService`). Used to show the offline banner immediately,
  /// without waiting for Firestore's own detection to catch up.
  final bool isOnline;

  List<ProductModel> get visibleProducts =>
      lowStockOnly ? products.where((p) => p.isLowStock).toList() : products;

  int get lowStockCount => products.where((p) => p.isLowStock).length;

  bool get showOfflineBanner => !isOnline || isFromCache;

  ProductListState copyWith({
    Status? status,
    AppError? error,
    List<ProductModel>? products,
    bool? isFromCache,
    bool? isOnline,
  }) => ProductListState(
    state: status ?? state,
    error: error,
    products: products ?? this.products,
    lowStockOnly: lowStockOnly,
    isFromCache: isFromCache ?? this.isFromCache,
    isOnline: isOnline ?? this.isOnline,
  );

  @override
  List<Object?> get props => [state, error, products, lowStockOnly, isFromCache, isOnline];
}
