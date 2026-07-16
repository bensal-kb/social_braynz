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
    final initial =
        product.name.isEmpty ? '?' : product.name.characters.first.toUpperCase();
    final stockColor =
        product.isLowStock ? context.theme.warning : context.theme.success;

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
          appBar: AppBar(title: const Text('Log Sale')),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<LogSaleCubit, LogSaleState>(
              builder: (context, state) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: context.theme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.theme.divider),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: context.theme.primary.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            initial,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: context.theme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          product.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: context.theme.text,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${formatCurrency(product.price)} each',
                          style: TextStyle(fontSize: 13, color: context.theme.hint),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: stockColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${product.quantity} in stock',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: stockColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Quantity',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: context.theme.hint),
                  ),
                  const SizedBox(height: 8),
                  QuantityStepper(
                    quantity: state.quantityToSell,
                    onIncrement: () => context.read<LogSaleCubit>().increment(),
                    onDecrement: () => context.read<LogSaleCubit>().decrement(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Total: ${formatCurrency(product.price * state.quantityToSell)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: context.theme.text,
                    ),
                  ),
                  if (state.quantityToSell > product.quantity) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: context.theme.warning.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 18,
                            color: context.theme.warning,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Only ${product.quantity} in stock — this may be rejected if you\'re online.',
                              style: TextStyle(
                                fontSize: 12,
                                color: context.theme.text,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(),
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
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
