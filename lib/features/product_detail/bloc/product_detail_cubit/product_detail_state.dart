import '../../../../core/base/base_bloc/base_states.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/models/sale_model.dart';

class ProductDetailState extends BaseState {
  const ProductDetailState({
    super.state,
    super.error,
    this.product,
    this.recentSales = const [],
  });

  final ProductModel? product;
  final List<SaleModel> recentSales;

  ProductDetailState copyWith({
    Status? status,
    AppError? error,
    ProductModel? product,
    List<SaleModel>? recentSales,
  }) => ProductDetailState(
    state: status ?? state,
    error: error,
    product: product ?? this.product,
    recentSales: recentSales ?? this.recentSales,
  );

  @override
  List<Object?> get props => [state, error, product, recentSales];
}
