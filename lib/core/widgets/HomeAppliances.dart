import 'package:flutter/material.dart';

class HomeAppliances extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal:15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Home Appliances',
            style:  TextStyle(
              fontSize: 18,
              color:Color(0xca000000),
            ),
          ),
        ],
      ),
    );
  }

}