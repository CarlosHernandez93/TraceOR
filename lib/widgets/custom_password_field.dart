import 'package:trace_or/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomPasswordField extends StatefulWidget {
  
  final TextEditingController controller;
  final String hintText;

  const CustomPasswordField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {

  bool obscureText = true;

  void togglePasswordView() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: togglePasswordView,
        ),
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}