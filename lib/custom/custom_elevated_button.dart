import 'package:flutter/material.dart';
import 'package:prime_basket_place_mobile/dashboard/screens/add_product_form.dart';
import 'package:prime_basket_place_mobile/models/product.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:prime_basket_place_mobile/dashboard/services/delete_srv.dart';
import 'package:prime_basket_place_mobile/dashboard/widgets/delete_product.dart';

// custom button for edit, delete product

class ProductActionButton extends StatelessWidget {
  final Product product;

  const ProductActionButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.more_vert, color: Colors.white),
      label: const Text(
        "Product Actions",
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (_) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit Product'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddProductFormPage(product: product),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Delete Product',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context); // tutup bottom sheet

                    final request = context.read<CookieRequest>();

                    showDialog(
                      context: context,
                      builder: (_) => DeleteProductDialog(
                        onConfirm: () async {
                          // debugPrint("DELETE: product id = ${product.pk}");

                          final response = await ProductService.deleteProduct(
                            request,
                            product.pk,
                          );

                          // debugPrint("DELETE RESPONSE: $response");

                          if (!context.mounted) return;

                          if (response["status"] == "success") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Produk berhasil dihapus"),
                              ),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  response["message"] ??
                                      "Gagal menghapus produk",
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: 8),
              ],
            );
          },
        );
      },
    );
  }
}
