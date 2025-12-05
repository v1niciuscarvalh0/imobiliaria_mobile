import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/pages/home_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema Imobiliário',
      theme: AppTheme.theme,
      home: HomePage(),
    );
  }
}
