import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  const Category({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            height: 100,
            width: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/categories.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height:8),
        const Text(
          "men's fashion",
          style: TextStyle(color:Color(0xff0d548a), fontSize: 14),
        ),
      ],
    );
  }
}