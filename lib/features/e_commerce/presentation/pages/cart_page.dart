import 'package:e_commerce_app/core/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/core/app_theme.dart';
import 'package:e_commerce_app/core/widgets/loading_widget.dart';
import 'package:e_commerce_app/features/Api/response/ProductDM.dart';
import 'package:e_commerce_app/features/e_commerce/presentation/pages/product_Details.dart';

import '../bloc/cart_bloc/cart_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: appTheme.textTheme.displayLarge,
        ),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (_) => CartBloc(),
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const LoadingWidget();
            } else if (state is CartLoaded) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = state.cartItems[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetails(
                                  product: ProductDM(
                                    sold: item['sold'],
                                    id: item['productId'],
                                    title: item['title'],
                                    description: item['description'],
                                    price: item['price'],
                                    ratingsAverage: item['ratingsAverage'],
                                    images: [item['image']],
                                  ),
                                  counter: item['quantity'],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  item['image'] != null
                                      ? Image.network(
                                          item['image'],
                                          width: 100,
                                          height: 100,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(Icons.error);
                                          },
                                        )
                                      : const Icon(Icons.image),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['title'],
                                          style: const TextStyle(fontSize: 18),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '\$${item['price'].toStringAsFixed(2)}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      BlocProvider.of<CartBloc>(context).add(
                                        DeleteCartItem(item.id),
                                      );
                                      showToast("Product Deleted Successfuly");
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Total: EGP ${state.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        BlocProvider.of<CartBloc>(context)
                            .add(DeleteAllCartItems());
                        showToast("Tahnks, Products will be delivered to you.");
                      },
                      child: Container(
                        height: screenHeight * 0.05,
                        decoration: BoxDecoration(
                          color: const Color(0xff035696),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Check Out ',
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: Colors.white,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_right_alt,
                              size: 20,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is CartError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(
                  child: Text('Please login to view your cart'));
            }
          },
        ),
      ),
    );
  }
}
