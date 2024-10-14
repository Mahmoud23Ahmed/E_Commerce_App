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
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Cart',
              style: appTheme.textTheme.displayLarge?.copyWith(
                fontSize: screenWidth * 0.05,
              ),
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
                  return Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
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
                                          ratingsAverage:
                                              item['ratingsAverage'],
                                          images: [item['image']],
                                        ),
                                        counter: item['quantity'],
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  margin: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.01),
                                  child: Padding(
                                    padding: EdgeInsets.all(screenWidth * 0.04),
                                    child: Row(
                                      children: [
                                        item['image'] != null
                                            ? Image.network(
                                                item['image'],
                                                width: screenWidth * 0.25,
                                                height: screenHeight * 0.12,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const Icon(
                                                      Icons.error);
                                                },
                                              )
                                            : const Icon(Icons.image),
                                        SizedBox(width: screenWidth * 0.04),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['title'],
                                                style: TextStyle(
                                                  fontSize: screenWidth * 0.045,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                  height: screenHeight * 0.005),
                                              Text(
                                                '\$${item['price'].toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontSize: screenWidth * 0.04,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              size: screenWidth * 0.06),
                                          onPressed: () {
                                            BlocProvider.of<CartBloc>(context)
                                                .add(DeleteCartItem(item.id));
                                            showToast(
                                                "Product Deleted Successfully");
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          'Total: EGP ${state.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: screenWidth * 0.045),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        GestureDetector(
                          onTap: () {
                            if (state.cartItems.isEmpty) {
                              showToast("There is no items in your cart.");
                            } else {
                              BlocProvider.of<CartBloc>(context)
                                  .add(DeleteAllCartItems());
                              showToast(
                                  "Thanks, Products will be delivered to you.");
                            }
                          },
                          child: Container(
                            height: screenHeight * 0.06,
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
                                    fontSize: screenWidth * 0.045,
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_right_alt,
                                  size: screenWidth * 0.06,
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
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(fontSize: screenWidth * 0.05),
                    ),
                  );
                } else {
                  return const Center(
                      child: Text('Please login to view your cart'));
                }
              },
            ),
          ),
        );
      },
    );
  }
}
