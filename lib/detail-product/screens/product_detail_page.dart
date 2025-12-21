import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:prime_basket_place_mobile/detail-product/models/product_detail.dart';
import 'package:prime_basket_place_mobile/detail-product/screens/edit_description_form.dart';
import 'package:prime_basket_place_mobile/review/widgets/review_button.dart';
import 'package:prime_basket_place_mobile/custom/custom_elevated_button.dart';
import 'package:prime_basket_place_mobile/models/product.dart';
import 'package:prime_basket_place_mobile/dashboard/widgets/favorite_button.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId; // ID produk yang diklik dari list

  const ProductDetailPage({super.key, required this.productId});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Future<List<Product>> fetchProductDetail(CookieRequest request) async {
    try {
      var response = await request.get(
        'http://localhost:8000/detail/product/${widget.productId}/detail-json/',
      );

      List<Product> listProduct = [];

      // Handle null response
      if (response == null) {
        throw Exception('Response adalah null');
      }

      // Jika response adalah list
      if (response is List) {
        for (var d in response) {
          if (d != null) {
            listProduct.add(Product.fromJson(d));
          }
        }
      } else if (response is Map) {
        // Jika response adalah single object, tambahkan ke list
        listProduct.add(Product.fromJson(Map<String, dynamic>.from(response)));
      } else {
        throw Exception(
          'Format response tidak dikenali: ${response.runtimeType}',
        );
      }

      return listProduct;
    } catch (e) {
      print('Error saat fetch product detail: $e');
      throw Exception('Gagal memuat detail produk: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: Color(0xFFF0F0F0),
      ),
      body: FutureBuilder(
        future: fetchProductDetail(request),
        builder: (context, AsyncSnapshot snapshot) {
          // Tangani error
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Gagal memuat data produk',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            );
          }

          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Check if data is null atau empty
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text("Data produk tidak ditemukan."));
          }

          // Success state
          Product product = snapshot.data![0]; // Ambil item pertama
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  product.fields.imageUrl,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 300,
                    color: Colors.grey,
                    child: const Center(child: Text("Gagal memuat gambar")),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.fields.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Brand: ${product.fields.brand}",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        "Kategori: ${product.fields.category}",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Rp ${product.fields.price}",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Deskripsi:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        (product.fields.description == null ||
                                product.fields.description.trim().isEmpty)
                            ? "Belum ada deskripsi."
                            : product.fields.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),

                      // tombol action (delete, edit)
                      SizedBox(
                        width: double.infinity,
                        child: FavoriteButton(
                          productId: product.pk,
                          initialFavorite: false,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // tombol action (delete, edit)
                      SizedBox(
                        width: double.infinity,
                        child: ProductActionButton(product: product),
                      ),

                      const SizedBox(height: 12),

                      // Tombol Edit Deskripsi
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditDescriptionForm(productId: product.pk),
                              ),
                            ).then(
                              (_) => setState(() {}),
                            ); // Refresh setelah kembali
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                          ),
                          child: const Text(
                            "Edit Deskripsi",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        child: ReviewProductButton(
                          productId: product.pk.toString(),
                          productName: product.fields.name,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
