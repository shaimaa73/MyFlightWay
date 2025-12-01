import 'package:flutter/material.dart';

class SettingsPageScreen extends StatelessWidget {
  const SettingsPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
          'Settings Page',
          style: TextStyle(fontSize: 22, color: Color(0xFF536D82)),
        ),
    );
  }
}