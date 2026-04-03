import 'package:flutter/material.dart';

class MTextfield extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isVisible;
  final bool isPassword;
  final ColorScheme colorScheme;
  final TextEditingController? controller;
  final VoidCallback? onSuffixIconPressed;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  const MTextfield({
    super.key,
    this.validator,
    required this.icon,
    required this.label,
    this.isVisible = false,
    this.isPassword = false,
    this.onSuffixIconPressed,
    required this.colorScheme,
    this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword && !isVisible,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: onSuffixIconPressed,
              )
            : null,
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withAlpha(128),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
    );
  }
}
