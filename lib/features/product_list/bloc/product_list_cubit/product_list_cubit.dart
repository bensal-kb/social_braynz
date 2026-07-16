import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/base_bloc/base_states.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/repo/product_repo.dart';
import 'product_list_state.dart';

class ProductListCubit extends Cubit<ProductListState> {
  ProductListCubit(this._repo, this._connectivityService, {bool lowStockOnly = false})
    : super(
        ProductListState(
          lowStockOnly: lowStockOnly,
          isOnline: _connectivityService.lastKnownOnline ?? true,
        ),
      );

  final ProductRepo _repo;
  final ConnectivityService _connectivityService;
  StreamSubscription<List<ProductModel>>? _productsSub;
  StreamSubscription<bool>? _cacheSub;
  StreamSubscription<bool>? _onlineSub;

  void watch() {
    emit(state.copyWith(status: Status.loading));
    _productsSub = _repo.watchProducts().listen(
      (products) => emit(state.copyWith(status: Status.success, products: products)),
      onError: (Object e) =>
          emit(state.copyWith(status: Status.error, error: mapFirestoreError(e))),
    );
    _cacheSub = _repo.watchIsFromCache().listen(
      (isFromCache) => emit(state.copyWith(isFromCache: isFromCache)),
      // Errors already surface through the products stream above; the cache
      // banner just stops updating.
      onError: (Object _) {},
    );
    _onlineSub = _connectivityService.onlineStatus.listen(
      (isOnline) => emit(state.copyWith(isOnline: isOnline)),
      onError: (Object _) {},
    );
  }

  @override
  Future<void> close() {
    _productsSub?.cancel();
    _cacheSub?.cancel();
    _onlineSub?.cancel();
    return super.close();
  }
}
