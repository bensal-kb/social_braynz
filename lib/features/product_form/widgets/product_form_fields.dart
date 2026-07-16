import '../../../core/base/base_ui/base_ui.dart';
import '../../../widgets/fields/app_text_field.dart';
import '../bloc/product_form_cubit/product_form_cubit.dart';

class ProductFormFields extends StatelessWidget {
  const ProductFormFields({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductFormCubit>();
    final state = context.watch<ProductFormCubit>().state;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: 'Product name',
            initialValue: state.name,
            onChanged: cubit.nameChanged,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Name is required' : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Quantity',
            initialValue: state.quantity == 0 ? '' : state.quantity.toString(),
            keyboardType: TextInputType.number,
            onChanged: (v) => cubit.quantityChanged(int.tryParse(v) ?? 0),
            validator: (v) {
              final n = int.tryParse(v ?? '');
              if (n == null || n < 0) return 'Enter a valid quantity';
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Price',
            prefixText: '\$ ',
            initialValue: state.price == 0 ? '' : state.price.toString(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (v) => cubit.priceChanged(double.tryParse(v) ?? 0),
            validator: (v) {
              final n = double.tryParse(v ?? '');
              if (n == null || n < 0) return 'Enter a valid price';
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Low-stock threshold',
            initialValue: state.lowStockThreshold.toString(),
            keyboardType: TextInputType.number,
            onChanged: (v) => cubit.thresholdChanged(int.tryParse(v) ?? 0),
            validator: (v) {
              final n = int.tryParse(v ?? '');
              if (n == null || n < 0) return 'Enter a valid threshold';
              return null;
            },
          ),
        ],
      ),
    );
  }
}
