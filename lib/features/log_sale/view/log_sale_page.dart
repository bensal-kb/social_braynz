import 'package:go_router/go_router.dart';

import '../../../core/base/base_ui/base_page.dart';
import '../../../core/base/base_ui/base_ui.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/product_model.dart';
import '../bloc/log_sale_cubit/log_sale_cubit.dart';
import '../bloc/log_sale_cubit/log_sale_state.dart';
import '../widgets/quantity_stepper.dart';

class LogSalePage extends StatelessWidget {
  const LogSalePage({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LogSaleCubit(saleRepo, product: product),
      child: BlocListener<LogSaleCubit, LogSaleState>(
        listener: (context, state) {
          if (state.isSuccess) context.pop();
          if (state.isError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error?.message ?? 'Failed to log sale')),
            );
          }
        },
        child: BasePage(
          appBar: AppBar(title: Text('Log Sale — ${product.name}')),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Currently ${product.quantity} in stock', style: TextStyle(color: context.theme.hint)),
                const SizedBox(height: 24),
                BlocBuilder<LogSaleCubit, LogSaleState>(
                  builder: (context, state) => Column(
                    children: [
                      QuantityStepper(
                        quantity: state.quantityToSell,
                        onIncrement: () => context.read<LogSaleCubit>().increment(),
                        onDecrement: () => context.read<LogSaleCubit>().decrement(),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Total: ${formatCurrency(product.price * state.quantityToSell)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      if (state.quantityToSell > product.quantity) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Only ${product.quantity} in stock — this may be rejected if you\'re online.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: context.theme.warning),
                        ),
                      ],
                      const SizedBox(height: 32),
                      FilledButton(
                        onPressed: state.isLoading
                            ? null
                            : () => context.read<LogSaleCubit>().submit(),
                        child: state.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Confirm Sale'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
