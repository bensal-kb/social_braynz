import '../../core/base/base_ui/base_ui.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.initialValue,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.prefixText,
  });

  final String label;
  final String? initialValue;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final String? prefixText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefixText,
      ),
    );
  }
}
