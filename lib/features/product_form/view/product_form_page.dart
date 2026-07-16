import 'package:go_router/go_router.dart';

import '../../../core/base/base_ui/base_page.dart';
import '../../../core/base/base_ui/base_ui.dart';
import '../../../core/base/base_ui/widgets/default_loading_widget.dart';
import '../../../data/models/product_model.dart';
import '../bloc/product_form_cubit/product_form_cubit.dart';
import '../bloc/product_form_cubit/product_form_state.dart';
import '../widgets/product_form_fields.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key, this.productId});

  final String? productId;

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  late final Future<ProductModel?> _existingFuture = widget.productId == null
      ? Future.value(null)
      : productRepo.getProduct(widget.productId!);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProductModel?>(
      future: _existingFuture,
      builder: (context, snapshot) {
        if (widget.productId != null && !snapshot.hasData) {
          return const BasePage(child: DefaultLoadingWidget());
        }
        return BlocProvider(
          create: (_) => ProductFormCubit(productRepo, existing: snapshot.data),
          child: BlocListener<ProductFormCubit, ProductFormState>(
            listener: (context, state) {
              if (state.isSuccess) context.pop();
              if (state.isError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error?.message ?? 'Failed to save product')),
                );
              }
            },
            child: Builder(
              builder: (context) {
                final isEditing = context.watch<ProductFormCubit>().state.isEditing;
                return BasePage(
                  appBar: AppBar(title: Text(isEditing ? 'Edit Product' : 'Add Product')),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ProductFormFields(formKey: _formKey),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<ProductFormCubit>().submit();
                            }
                          },
                          child: Text(isEditing ? 'Save Changes' : 'Add Product'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
