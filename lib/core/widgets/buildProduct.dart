import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/features/Api/response/ProductDM.dart';
import 'package:e_commerce_app/features/e_commerce/presentation/pages/product_Details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<bool> checkIfFavorited(
    String? productId, CollectionReference favItemsCollection) async {
  final querySnapshot =
      await favItemsCollection.where('productId', isEqualTo: productId).get();
  return querySnapshot.docs.isNotEmpty;
}

Widget buildProductsCard(List<ProductDM> products, String _searchQuery) {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final favItemsCollection =
      _firestore.collection('users').doc(userId).collection('FavItems');

  List<ProductDM> filteredProducts = products.where((product) {
    return product.title!.toLowerCase().contains(_searchQuery.toLowerCase());
  }).toList();

  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.75,
    ),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: filteredProducts.length,
    itemBuilder: (context, index) {
      final product = filteredProducts[index];

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetails(product: product),
            ),
          );
        },
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(
                      product.images!.first,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: FutureBuilder<bool>(
                        future:
                            checkIfFavorited(product.id, favItemsCollection),
                        builder: (context, snapshot) {
                          IconData icon = Icons.favorite_border;
                          Color iconColor = const Color(0xff035696);

                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.data == true) {
                              icon = Icons.favorite;
                              iconColor = const Color(0xff035696);
                            }
                          }

                          return IconButton(
                            icon: Icon(
                              icon,
                              color: iconColor,
                              size: 30,
                            ),
                            onPressed: () async {
                              if (snapshot.data == true) {
                                final querySnapshot = await favItemsCollection
                                    .where('productId', isEqualTo: product.id)
                                    .get();
                                if (querySnapshot.docs.isNotEmpty) {
                                  for (var doc in querySnapshot.docs) {
                                    await doc.reference.delete();
                                  }
                                }
                              } else {
                                await favItemsCollection.add({
                                  'productId': product.id,
                                  'title': product.title,
                                  'price': product.price,
                                  'image': product.images!.first,
                                  'sold': product.sold,
                                  'description': product.description,
                                  'ratingsAverage': product.ratingsAverage,
                                });
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  product.title.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '\$${product.price}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff035696),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
