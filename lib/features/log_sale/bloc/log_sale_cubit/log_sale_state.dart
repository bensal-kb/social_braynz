import '../../../../core/base/base_bloc/base_states.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../data/models/product_model.dart';

class LogSaleState extends BaseState {
  const LogSaleState({
    super.state,
    super.error,
    required this.product,
    this.quantityToSell = 1,
  });

  final ProductModel product;
  final int quantityToSell;

  LogSaleState copyWith({Status? status, AppError? error, int? quantityToSell}) =>
      LogSaleState(
        state: status ?? state,
        error: error,
        product: product,
        quantityToSell: quantityToSell ?? this.quantityToSell,
      );

  @override
  List<Object?> get props => [state, error, product, quantityToSell];
}
