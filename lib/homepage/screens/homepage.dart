import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:prime_basket_place_mobile/models/product.dart'; // Import model tadi
import 'package:prime_basket_place_mobile/custom/custom_app_bar.dart';
import 'package:prime_basket_place_mobile/custom/custom_drawer.dart';
import 'package:prime_basket_place_mobile/detail-product/screens/product_detail_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Fungsi untuk mengambil data dari Django
  Future<List<Product>> fetchProduct(CookieRequest request) async {
    // GANTI URL INI dengan URL PWS Anda atau http://10.0.2.2:8000/json/ jika di emulator
    var response = await request.get('https://rafsanjani41-primebasketplace.pbp.cs.ui.ac.id/json/');

    List<Product> listProduct = [];
    for (var d in response) {
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
      backgroundColor: Color(0xFFF0F0F0),
      appBar: const CustomShopAppBar(), // Menggunakan AppBar custom Anda
      drawer: const LeftDrawer(), // Menggunakan Drawer custom Anda
      body: FutureBuilder(
        future: fetchProduct(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Center(
                child: Text(
                  "Tidak ada data produk.",
                  style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                ),
              );
            } else {
              // Tampilkan data dalam Grid atau List
              return GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Menampilkan 2 produk per baris
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  var product = snapshot.data![index];

                  return InkWell(
                    onTap: () {
                      // Navigasi ke detail product
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailPage(productId: product.pk),
                        ),
                      );
                    },
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Image.network(
                              'https://rafsanjani41-primebasketplace.pbp.cs.ui.ac.id/dashboard/proxy-image/?url=${Uri.encodeComponent(product.fields.imageUrl)}',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (ctx, error, stackTrace) =>
                                  const Center(child: Icon(Icons.error)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.fields.name,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Rp ${product.fields.price}",
                                  style: const TextStyle(
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
