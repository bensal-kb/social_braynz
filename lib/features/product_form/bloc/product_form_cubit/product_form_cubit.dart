import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/base_bloc/base_states.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/repo/product_repo.dart';
import 'product_form_state.dart';

class ProductFormCubit extends Cubit<ProductFormState> {
  ProductFormCubit(this._repo, {ProductModel? existing})
    : super(
        ProductFormState(
          id: existing?.id,
          name: existing?.name ?? '',
          quantity: existing?.quantity ?? 0,
          price: existing?.price ?? 0,
          lowStockThreshold: existing?.lowStockThreshold ?? 5,
        ),
      );

  final ProductRepo _repo;

  void nameChanged(String value) => emit(state.copyWith(name: value));
  void quantityChanged(int value) => emit(state.copyWith(quantity: value));
  void priceChanged(double value) => emit(state.copyWith(price: value));
  void thresholdChanged(int value) =>
      emit(state.copyWith(lowStockThreshold: value));

  Future<void> submit() async {
    emit(state.copyWith(status: Status.loading));
    final product = ProductModel(
      id: state.id ?? _repo.newId(),
      name: state.name.trim(),
      quantity: state.quantity,
      price: state.price,
      lowStockThreshold: state.lowStockThreshold,
      updatedAt: DateTime.now(),
    );
    try {
      if (state.isEditing) {
        await _repo.updateProduct(product);
      } else {
        await _repo.addProduct(product);
      }
      emit(state.copyWith(status: Status.success));
    } catch (e) {
      emit(state.copyWith(status: Status.error, error: mapFirestoreError(e)));
    }
  }
}
