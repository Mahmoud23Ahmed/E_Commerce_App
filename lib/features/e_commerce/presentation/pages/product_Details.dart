import 'package:e_commerce_app/features/Api/response/ProductDM.dart';
import 'package:e_commerce_app/features/e_commerce/presentation/pages/cart_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/widgets/toast.dart';

class ProductDetails extends StatefulWidget {
  final ProductDM product;
  final int? counter;

  const ProductDetails({
    super.key,
    required this.product,
    this.counter,
  });

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int _counter = 1;
  num _totalPrice = 0.0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _incrementCounter() {
    setState(() {
      _counter++;
      _totalPrice = _counter * (widget.product.price ?? 0);
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 1) {
        _counter--;
        _totalPrice = _counter * (widget.product.price ?? 0);
      }
    });
  }

  @override
  void initState() {
    _totalPrice = widget.product.price ?? 0;
    _counter = widget.counter ?? 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff035696),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Product Details'),
        centerTitle: true,
        // actions: [
        //   GestureDetector(
        //     onTap: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => CartPage(),
        //         ),
        //       );
        //     },
        //     child: const Icon(
        //       Icons.shopping_cart,
        //       size: 25,
        //     ),
        //   ),
        //   const SizedBox(
        //     width: 30,
        //   )
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.2,
              child: Image.network(
                widget.product.images!.first,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.title.toString(),
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '\$${widget.product.price}',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border:
                              Border.all(color: Colors.grey[500]!, width: 1),
                        ),
                        child: Text(
                          '${widget.product.sold} Sold',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          Text('${widget.product.ratingsAverage}'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    widget.product.description.toString(),
                    style: TextStyle(fontSize: screenWidth * 0.030),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total price',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  height: screenHeight * 0.05,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff035696),
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: _decrementCounter,
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                          size: 20,
                                        ),
                                        color: Colors.white,
                                      ),
                                      Text(
                                        '$_counter',
                                        style: TextStyle(
                                            fontSize: screenWidth * 0.035,
                                            color: Colors.white),
                                      ),
                                      IconButton(
                                        onPressed: _incrementCounter,
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                          size: 20,
                                        ),
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${_totalPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    final userId =
                                        FirebaseAuth.instance.currentUser!.uid;

                                    final cartItemsCollection = _firestore
                                        .collection('users')
                                        .doc(userId)
                                        .collection('cartItems');

                                    final querySnapshot =
                                        await cartItemsCollection
                                            .where('productId',
                                                isEqualTo: widget.product.id)
                                            .get();

                                    if (querySnapshot.docs.isNotEmpty) {
                                      showToast(
                                          "Product already exists in cart");
                                    } else {
                                      await cartItemsCollection.add({
                                        'productId': widget.product.id,
                                        'title': widget.product.title,
                                        'price': widget.product.price,
                                        'quantity': _counter,
                                        'image': widget.product.images!.first,
                                        'sold': widget.product.sold,
                                        'description':
                                            widget.product.description,
                                        'ratingsAverage':
                                            widget.product.ratingsAverage
                                      });

                                      showToast("Product Added to Cart");
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff035696),
                                  ),
                                  child: const Text(
                                    'Add to cart',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
