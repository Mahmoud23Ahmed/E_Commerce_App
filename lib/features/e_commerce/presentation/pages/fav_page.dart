import 'package:e_commerce_app/core/widgets/toast.dart';
import 'package:e_commerce_app/features/e_commerce/presentation/bloc/Fav_bloc/Fav_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/core/app_theme.dart';
import 'package:e_commerce_app/core/widgets/loading_widget.dart';
import 'package:e_commerce_app/features/Api/response/ProductDM.dart';
import 'package:e_commerce_app/features/e_commerce/presentation/pages/product_Details.dart';

class FavPage extends StatelessWidget {
  const FavPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite Products',
          style: appTheme.textTheme.displayLarge,
        ),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (_) => FavBloc(),
        child: BlocBuilder<FavBloc, FavState>(
          builder: (context, state) {
            if (state is FavLoading) {
              return const LoadingWidget();
            } else if (state is FavLoaded) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.FavItems.length,
                      itemBuilder: (context, index) {
                        final item = state.FavItems[index];
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
                                      BlocProvider.of<FavBloc>(context).add(
                                        DeleteFavItem(item.id),
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
                  ],
                ),
              );
            } else if (state is FavError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(
                  child: Text('Please login to view your Fav Products'));
            }
          },
        ),
      ),
    );
  }
}
