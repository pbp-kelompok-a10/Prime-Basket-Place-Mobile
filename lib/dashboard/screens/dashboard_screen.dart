import 'package:flutter/material.dart';
import 'package:prime_basket_place_mobile/custom/custom_app_bar.dart';
import 'package:prime_basket_place_mobile/custom/custom_drawer.dart';
import 'package:prime_basket_place_mobile/dashboard/widgets/product_card.dart';
import 'package:prime_basket_place_mobile/dashboard/screens/add_product_form.dart';
import 'package:prime_basket_place_mobile/models/product.dart';
import 'package:prime_basket_place_mobile/detail-product/screens/product_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<List<Product>> fetchNews(CookieRequest request) async {
    final response = await request.get(
      'https://rafsanjani41-primebasketplace.pbp.cs.ui.ac.id/dashboard/json/',
    );

    // Decode response to json format
    var data = response;

    // Convert json data to Product objects
    List<Product> listProduct = [];
    for (var d in data) {
      if (d != null) {
        listProduct.add(Product.fromJson(d));
      }
    }
    return listProduct;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 229, 229, 229),
      appBar: const CustomShopAppBar(),
      drawer: const LeftDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// PAGE TITLE
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Text(
              "My Product",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4C2FA0),
                fontFamily: 'Roboto',
              ),
            ),
          ),

          /// PRODUCT LIST
          FutureBuilder<List<Product>>(
            future: fetchNews(request),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    "Tidak ada produk.",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              final products = snapshot.data!;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 card per row
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return ProductCard(
                    product: product,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailPage(productId: product.pk),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action here
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Button pressed!')));
          // Navigate to form
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductFormPage()),
          );
        },
        backgroundColor: Color(0xFF4C2FA0),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
