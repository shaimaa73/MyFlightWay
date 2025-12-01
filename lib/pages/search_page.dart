import 'package:flutter/material.dart';

class SearchPageScreen extends StatelessWidget {
  const SearchPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
          'Search Page',
          style: TextStyle(fontSize: 22, color: Color(0xFF536D82)),
        ),
    );
  }
}