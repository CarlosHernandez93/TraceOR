import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme{
  static ThemeData get getTheme => ThemeData(
    primaryColor: AppColors.colorOne,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}