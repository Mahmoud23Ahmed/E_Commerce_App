import 'package:e_commerce_app/core/widgets/Category.dart';
import 'package:flutter/material.dart';

class CategoryBuilder extends StatelessWidget{
  @override
  Widget build(BuildContext context) => ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 270,
      ),
      child: GridView.builder(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Category();
        },
        itemCount: 20,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two items per row
        ),
      ),
    );
}