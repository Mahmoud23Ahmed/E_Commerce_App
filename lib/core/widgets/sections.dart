import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  final String secName;
  final Function function;
  const Section(
      {super.key, required this.secName, required this.function});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            secName,
            style: const TextStyle(
              fontSize: 18,
              color:Color(0xca000000),
            ),
          ),
          TextButton(
            onPressed: () {
              function();
            },
            child: const Text(
              'view all',
              style: TextStyle(color:Color(0xff035696)),
            ),
          ),
        ],
      ),
    );
  }
}