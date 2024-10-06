import 'package:trace_or/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData? icon;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.icon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon) : null,
        hintText: hintText,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: AppColors.colorOne, width: 2.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.grey, width: 2.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none
        ),
        labelStyle: const TextStyle(
          color: Color(0xFF000000),
          fontFamily: "OpenSans",
        ),
        hintStyle: const TextStyle(
          fontFamily: "OpenSans", color: Color.fromARGB(255, 108, 108, 108)
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 238, 238, 238),
        contentPadding: const EdgeInsets.all(15.0),
      ),
      validator: validator,
    );
  }
}