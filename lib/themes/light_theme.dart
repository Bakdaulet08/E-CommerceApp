import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade100, // Это будет цвет для некоторых элементов
    primary: Colors.grey.shade200,
    secondary: Colors.grey.shade500,
    inversePrimary: Colors.grey.shade700,
    secondaryContainer: Colors.grey.shade300,
  ),
   scaffoldBackgroundColor: Colors.grey.shade300,
   // Устанавливаем черный цвет фона для Scaffold
);
