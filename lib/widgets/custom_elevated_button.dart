import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.blue, // Color del botón por defecto
    this.textColor = Colors.white, // Color del texto por defecto
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Color de fondo del botón // Color del texto
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Padding del botón
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Bordes redondeados
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 16, 
          fontWeight: FontWeight.bold), // Estilo del texto
      ),
    );
  }
}