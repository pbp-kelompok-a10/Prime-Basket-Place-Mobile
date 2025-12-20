import 'package:flutter/material.dart';
import 'package:prime_basket_place_mobile/custom/custom_app_bar.dart';
import 'package:prime_basket_place_mobile/custom/custom_drawer.dart';
import 'review/screens/review_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prime Basket Place',
      debugShowCheckedModeBanner: false, // Hilangkan banner debug
      theme: ThemeData(primarySwatch: Colors.deepPurple, fontFamily: 'Roboto'),
      home: const ReviewListScreen(
        productId: 'test-product-123', // ID produk untuk testing
        productName: 'Sample Product', // Nama produk untuk testing
      ),
    );
  }
}
