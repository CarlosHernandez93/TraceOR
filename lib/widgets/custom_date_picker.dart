import 'package:flutter/material.dart';
import 'package:trace_or/config/theme/app_colors.dart';

class DatePickerWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController dateController;
  final TextEditingController? ageController;
  final IconData? icon;
  final String? Function(String?)? validator;

  const DatePickerWidget({
    super.key,
    required this.hintText,
    required this.dateController,
    this.ageController,
    this.icon,
    this.validator,
  });

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('es', ''),
    );

    if (pickedDate != null) {
      // Calculamos la edad si el ageController es proporcionado
      if (widget.ageController != null) {
        int age = _calculateAge(pickedDate);
        widget.ageController!.text = age.toString(); // Actualiza el controlador
      }

      setState(() {
        // Establecemos la fecha en el controlador de fecha
        widget.dateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.dateController,
      readOnly: true,
      onTap: () => _selectDate(context),
      decoration: InputDecoration(
        prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
        hintText: widget.hintText,
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
          borderSide: BorderSide.none,
        ),
        labelStyle: const TextStyle(
          color: Color(0xFF000000),
          fontFamily: "OpenSans",
        ),
        hintStyle: const TextStyle(
          fontFamily: "OpenSans",
          color: Color.fromARGB(255, 108, 108, 108),
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 238, 238, 238),
        contentPadding: const EdgeInsets.all(15.0),
      ),
      validator: widget.validator,
    );
  }
}