import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'theme/app_theme.dart';

void main() => runApp(const CvFlutterApp());

class CvFlutterApp extends StatelessWidget {
  const CvFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CV Flutter',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const LoginPage(),
    );
  }
}