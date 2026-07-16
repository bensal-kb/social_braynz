import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/base_bloc/base_states.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/models/sale_model.dart';
import '../../../../data/repo/product_repo.dart';
import '../../../../data/repo/sale_repo.dart';
import '../../../../dependencies/get_dependencies.dart';
import 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit(this._productRepo, this._saleRepo, {required this.productId})
    : super(const ProductDetailState());

  final ProductRepo _productRepo;
  final SaleRepo _saleRepo;
  final String productId;

  StreamSubscription<ProductModel?>? _productSub;
  StreamSubscription<List<SaleModel>>? _salesSub;

  void watch() {
    emit(state.copyWith(status: Status.loading));

    // The product stream alone gates the page's loading/error state. Sales
    // are a secondary, independent list within the page (see
    // RecentSalesList's own empty state) — a brand-new product has no sales
    // yet, and that query can be slow to deliver its first offline snapshot
    // (a compound where+orderBy query the local cache has never run before).
    // Blocking the whole page on it made the page hang indefinitely offline
    // for a product with no sale history.
    _productSub = _productRepo.watchProduct(productId).listen(
      (product) => emit(
        ProductDetailState(state: Status.success, product: product, recentSales: state.recentSales),
      ),
      onError: (Object e) =>
          emit(state.copyWith(status: Status.error, error: mapFirestoreError(e))),
    );

    _salesSub = _saleRepo.watchSalesForProduct(productId).listen(
      (sales) => emit(state.copyWith(recentSales: sales)),
      onError: (Object e, StackTrace st) =>
          logger.e('watchSalesForProduct($productId) failed', error: e, stackTrace: st),
    );
  }

  Future<void> deleteProduct() => _productRepo.deleteProduct(productId);

  @override
  Future<void> close() {
    _productSub?.cancel();
    _salesSub?.cancel();
    return super.close();
  }
}
