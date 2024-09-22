import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/features/Api/response/categoryDm.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final categoryDM category;
  CategoryItem(this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Spacer(),
          CircleAvatar(
            radius: 30,
            backgroundImage: CachedNetworkImageProvider(category.image ?? ""),
          ),
          Spacer(),
          Text(
            category.name ?? "",
            textAlign: TextAlign.center,
            maxLines: 1,
          )
        ],
      ),
    );
  }
}