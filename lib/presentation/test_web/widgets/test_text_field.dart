import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final class TestTextField extends StatelessWidget {
  final String label;
  final ValueChanged<double> onChanged;
  final GlobalKey<FormState> formKey;

  const TestTextField({
    required this.label,
    required this.onChanged,
    required this.formKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: TextFormField(
          onChanged: (value) {
            final digit = double.tryParse(value.replaceAll(',', '.'));
            if (digit != null) onChanged(digit);
          },
          inputFormatters: [
            NumberInputFormatter(),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Field cannot be an empty.';
            }
            if (double.tryParse(value.replaceAll(',', '.')) == null) {
              return 'Incorrect value. Try again.';
            }

            return null;
          },
          decoration: InputDecoration(
            label: Text(label),
            labelStyle: const TextStyle(
              color: Colors.white,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text.replaceAll(RegExp('[^0-9.,]'), '');
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
