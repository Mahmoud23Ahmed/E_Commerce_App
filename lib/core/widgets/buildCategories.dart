import 'package:e_commerce_app/core/widgets/categoryItem.dart';
import 'package:e_commerce_app/core/widgets/productItem.dart';
import 'package:e_commerce_app/features/Api/response/ProductDM.dart';
import 'package:e_commerce_app/features/Api/response/categoryDm.dart';
import 'package:flutter/material.dart';

Widget buildCategories (List<categoryDM>list)=>
    SizedBox(
      height: 200,
      child: GridView.builder(
        itemCount: list.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context,index){
          return CategoryItem(list[index]);
        },
      ),
    );

Widget buildProducts (List<ProductDM>list)=>
    SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: list.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context,index){
          return Product(list[index]);
        },
      ),
    );