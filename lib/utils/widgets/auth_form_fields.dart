import 'package:flutter/material.dart';

class AuthEmailField extends StatelessWidget {
  final TextEditingController controller;
  final Color fillColor;
  final Color borderColor;
  final String? Function(String?)? validator;
  final String labelText;
  const AuthEmailField({
    super.key,
    required this.controller,
    required this.fillColor,
    required this.borderColor,
    required this.labelText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: const Icon(Icons.email, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        filled: true,
        fillColor: fillColor,
      ),
      keyboardType: TextInputType.text,
      validator: validator,
    );
  }
}

class AuthPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final Color fillColor;
  final Color borderColor;
  final String label;
  final bool obscureText;
  final String? Function(String?)? validator;
  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.fillColor,
    required this.borderColor,
    this.label = 'كلمة المرور',
    this.obscureText = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon:
            Icon(label == 'تأكيد كلمة المرور' ? Icons.lock_outline : Icons.lock, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        filled: true,
        fillColor: fillColor,
      ),
      obscureText: obscureText,
      validator: validator,
    );
  }
}
