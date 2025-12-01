import 'package:flutter/material.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Home Page',
        style: TextStyle(fontSize: 22, color: Color(0xFF536D82)),
      ),
    );
  }
}