import '../../../../core/base/base_bloc/base_states.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_error.dart';

class ProductFormState extends BaseState {
  const ProductFormState({
    super.state,
    super.error,
    this.id,
    this.name = '',
    this.quantity = 0,
    this.price = 0,
    this.lowStockThreshold = AppConstants.defaultLowStockThreshold,
  });

  final String? id;
  final String name;
  final int quantity;
  final double price;
  final int lowStockThreshold;

  bool get isEditing => id != null;

  ProductFormState copyWith({
    Status? status,
    AppError? error,
    String? name,
    int? quantity,
    double? price,
    int? lowStockThreshold,
  }) => ProductFormState(
    state: status ?? state,
    error: error,
    id: id,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    price: price ?? this.price,
    lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
  );

  @override
  List<Object?> get props => [state, error, id, name, quantity, price, lowStockThreshold];
}
