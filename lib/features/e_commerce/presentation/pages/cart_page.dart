import 'package:e_commerce_app/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int _counter = 1;
  num _totalPrice = 0.0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userId;
  List<QueryDocumentSnapshot> _cartItems = [];

  void _incrementCounter() {
    setState(() {
      _counter++;
      _totalPrice = _counter * _cartItems[0]['price']; // Update total price
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 1) {
        _counter--;
        _totalPrice = _counter * _cartItems[0]['price']; // Update total price
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  void _getCurrentUserId() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
    }
  }

  Future<String> _getImageFromApi(String productId) async {
    final response = await http
        .get(Uri.parse('https://fakestoreapi.com//products/$productId/image'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load image');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: TextStyle(color: primaryColor),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Icon(
            Icons.shopping_cart,
            color: primaryColor,
            size: 25,
          ),
          const SizedBox(
            width: 30,
          )
        ],
      ),
      body: _userId != null
          ? StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('users')
                  .doc(_userId)
                  .collection('cartItems')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Text('Loading....');
                  default:
                    _cartItems = snapshot.data!.docs;
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              FutureBuilder(
                                future: _getImageFromApi(
                                    _cartItems[0]['productId']),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Image.network(
                                      snapshot.data.toString(),
                                      width: 50,
                                      height: 50,
                                    );
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_cartItems[0]['title'],
                                        style: const TextStyle(fontSize: 18)),
                                    const SizedBox(height: 4),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Add delete functionality here
                                },
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  'EGP ${_cartItems[0]['price'].toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 16)),
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
                                        color: Colors.white,
                                      ),
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
                          const SizedBox(height: 20),
                          Container(
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
                        ],
                      ),
                    );
                }
              },
            )
          : const Center(
              child: Text('Please login to view your cart'),
            ),
    );
  }
}
