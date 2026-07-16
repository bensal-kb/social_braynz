import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/base_bloc/base_states.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/repo/sale_repo.dart';
import 'log_sale_state.dart';

class LogSaleCubit extends Cubit<LogSaleState> {
  LogSaleCubit(this._saleRepo, {required ProductModel product})
    : super(LogSaleState(product: product));

  final SaleRepo _saleRepo;

  void increment() => emit(state.copyWith(quantityToSell: state.quantityToSell + 1));

  void decrement() {
    if (state.quantityToSell <= 1) return;
    emit(state.copyWith(quantityToSell: state.quantityToSell - 1));
  }

  Future<void> submit() async {
    emit(state.copyWith(status: Status.loading));
    try {
      await _saleRepo.logSale(
        productId: state.product.id,
        productName: state.product.name,
        quantitySold: state.quantityToSell,
        unitPrice: state.product.price,
      );
      emit(state.copyWith(status: Status.success));
    } catch (e) {
      emit(state.copyWith(status: Status.error, error: mapFirestoreError(e)));
    }
  }
}
