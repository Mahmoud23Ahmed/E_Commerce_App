import 'dart:async';
import 'package:e_commerce_app/core/Constants/BaseStates.dart';
import 'package:e_commerce_app/core/Constants/product_state.dart';
import 'package:e_commerce_app/core/app_theme.dart';
import 'package:e_commerce_app/core/widgets/ErrorView.dart';
import 'package:e_commerce_app/core/widgets/HomeAppliances.dart';
import 'package:e_commerce_app/core/widgets/ads.dart';
import 'package:e_commerce_app/core/widgets/buildCategories.dart';
import 'package:e_commerce_app/core/widgets/sections.dart';
import 'package:e_commerce_app/features/Api/domain/HomeViewModel.dart';
import 'package:e_commerce_app/features/Api/domain/getIt.dart';
import 'package:e_commerce_app/features/Api/domain/product_view_model.dart';
import 'package:e_commerce_app/features/Api/response/ProductDM.dart';
import 'package:e_commerce_app/features/Api/response/categoryDm.dart';
import 'package:e_commerce_app/features/e_commerce/presentation/pages/contact_page.dart';
import 'package:e_commerce_app/features/e_commerce/presentation/pages/fav_page.dart';
import 'package:e_commerce_app/features/e_commerce/presentation/pages/product_Details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/loading_widget.dart';

class Home extends StatefulWidget {
  //static const String routeName = "Home";

  const Home({super.key});

  @override
  State<Home> createState() => _HomeTabState();
}

class _HomeTabState extends State<Home> {
  late HomeViewModel _homeViewModel;
  late ProductViewModel _productViewModel;
  int _adsIndex = 0;
  late Timer _timer;

  final List<String> adsImages = [
    'assets/images/CarouselSlider1.png',
    'assets/images/CarouselSlider2.png',
    'assets/images/CarouselSlider3.png',
  ];

  @override
  void initState() {
    super.initState();
    _homeViewModel = locator<HomeViewModel>();
    _productViewModel = locator<ProductViewModel>();
    _productViewModel.LoadProducts();
    _homeViewModel.LoadCategories();
    _startImageSwitching();
  }

  void _startImageSwitching() {
    _timer = Timer.periodic(const Duration(milliseconds: 2500), (Timer timer) {
      setState(() {
        _adsIndex = (_adsIndex + 1) % adsImages.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: secondaryColor,
        title: Image.asset('assets/images/route.png'),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            onPressed: () {},
                            icon: Image.asset('assets/images/search.png'),
                          ),
                          hintText: 'What do you search for?',
                          hintStyle: const TextStyle(color: Color(0xff035696)),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.5),
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(20.0),
                              right: Radius.circular(20.0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColor, width: 2.0),
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(20.0),
                              right: Radius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset('assets/images/cart.png'),
                    )
                  ],
                ),
                Ads(
                  adsImages: adsImages,
                  currentIndex: _adsIndex,
                  timer: _timer,
                ),
                Section(
                  function: () {},
                  secName: 'Categories',
                ),
                BlocConsumer(
                  bloc: locator<HomeViewModel>(),
                  builder: (context, state) {
                    if (state is BaseLoadingState) {
                      return const LoadingWidget(); // Show loading indicator
                    }
                    if (state is BaseSuccessState<List<categoryDM>>) {
                      return buildCategories(
                          state.data); // Display categories when loaded
                    }
                    if (state is BaseErrorState) {
                      return ErrorView(
                          message: state.errorMessage); // Show error message
                    } else {
                      return const LoadingWidget(); // Default fallback to loading
                    }
                  },
                  listener: (BuildContext context, Object? state) {},
                ),
                const SizedBox(height: 12),
                HomeAppliances(),
                BlocBuilder(
                  bloc: locator<ProductViewModel>(),
                  builder: (context, state) {
                    print('State: $state');
                    if (state is ProductSuccessState<List<ProductDM>>) {
                      return buildProducts(state.data);
                    }
                    if (state is ProductErrorState) {
                      return ErrorView(message: state.errorMessage);
                    }
                    if (state is ProductLoadingState) {
                      return const LoadingWidget();
                    } else {
                      return Container(
                        color: Colors.red,
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildProducts(List<ProductDM> products) {
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.75,
    ),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: products.length,
    itemBuilder: (context, index) {
      final product = products[index];
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
