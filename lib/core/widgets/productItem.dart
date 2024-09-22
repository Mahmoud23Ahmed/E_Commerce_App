import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/core/widgets/loading_widget.dart';
import 'package:e_commerce_app/features/Api/response/ProductDM.dart';
import 'package:flutter/material.dart';

class Product extends StatefulWidget {
  final ProductDM productDM;
  const Product(this.productDM, {super.key});

  @override
  State<Product> createState() => ProductState();
}

class ProductState extends State<Product> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(6),
        width: MediaQuery.of(context).size.width * .4,
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color:Colors.blue),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.productDM.imageCover??"" ,
                  placeholder: (_, __) => const LoadingWidget(),
                  errorWidget: (_, __, ___) => const Icon(Icons.error),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * .10,
                ),
                IconButton(color: Colors.red,
                  onPressed: () {}, // to be added in favourite screen //
                  icon: Image.asset('assets/images/favorites.png'),
                ),
              ],
            ),
            const Spacer(),
            Text(
              widget.productDM.title ?? "",
              textAlign: TextAlign.start,
              maxLines: 2,
              style: const TextStyle(height: 1),
            ),
            const Spacer(),
            Row(
              children: [
                Text("Review(${widget.productDM.ratingsAverage})"),
                const Icon(
                  Icons.star,
                  color: Colors.amberAccent,
                ),
              ],
            ),
            Row(
              children: [
                Text("EGP ${widget.productDM.price}"),
                const Spacer(),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: FloatingActionButton(
                    backgroundColor: Colors.blue,
                    onPressed: () {}, // to be added to cart screen //
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}