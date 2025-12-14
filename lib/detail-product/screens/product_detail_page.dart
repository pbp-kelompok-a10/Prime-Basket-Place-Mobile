import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:prime_basket_place_mobile/detail-product/models/product_detail.dart';
import 'package:prime_basket_place_mobile/detail-product/screens/edit_description_form.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId; // ID produk yang diklik dari list

  const ProductDetailPage({super.key, required this.productId});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Future<List<ProductDetail>> fetchProductDetail(CookieRequest request) async {
    var response = await request.get(
      'https://rafsanjani41-primebasketplace.pbp.cs.ui.ac.id/detail/json/${widget.productId}/detail-json',
    );

    List<ProductDetail> listProduct = [];
    for (var d in response) {
      if (d != null) {
        listProduct.add(ProductDetail.fromJson(d));
      }
    }
    return listProduct;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk')),
      body: FutureBuilder(
        future: fetchProductDetail(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Center(child: Text("Data produk tidak ditemukan."));
            } else {
              ProductDetail product = snapshot.data![0]; // Ambil item pertama
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
                            product.fields.description ??
                                "Belum ada deskripsi.",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),

                          // Tombol Edit Deskripsi
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditDescriptionForm(
                                      productId: product.pk,
                                    ),
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
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}
