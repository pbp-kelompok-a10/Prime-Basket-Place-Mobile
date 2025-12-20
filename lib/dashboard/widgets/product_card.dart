import 'package:flutter/material.dart';
import 'package:prime_basket_place_mobile/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.onTap, required this.product});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    /// simple responsive scale
    final scale = screenWidth < 360
        ? 0.9
        : screenWidth > 600
        ? 1.1
        : 1.0;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12 * scale),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE + BADGES
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    'http://localhost:8000/dashboard/proxy-image/?url=${Uri.encodeComponent(product.fields.imageUrl)}',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.broken_image)),
                    ),
                  ),
                ),

                /// DISCOUNT BADGE
                // Positioned(
                //   top: 8 * scale,
                //   left: 8 * scale,
                //   child: Container(
                //     padding: EdgeInsets.symmetric(
                //       horizontal: 8 * scale,
                //       vertical: 4 * scale,
                //     ),
                //     decoration: BoxDecoration(
                //       color: Colors.redAccent,
                //       borderRadius: BorderRadius.circular(12 * scale),
                //     ),
                //     child: Text(
                //       '99%',
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 12 * scale,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),

                /// FAVORITE ICON
                // Positioned(
                //   top: 8 * scale,
                //   right: 8 * scale,
                //   child: Icon(
                //     Icons.favorite_border,
                //     color: Colors.deepPurple,
                //     size: 22 * scale,
                //   ),
                // ),

                /// FEATURED BADGE
                // Positioned(
                //   bottom: 8 * scale,
                //   left: 8 * scale,
                //   child: Container(
                //     padding: EdgeInsets.symmetric(
                //       horizontal: 10 * scale,
                //       vertical: 4 * scale,
                //     ),
                //     decoration: BoxDecoration(
                //       color: Colors.lightGreen,
                //       borderRadius: BorderRadius.circular(20 * scale),
                //     ),
                //     child: Text(
                //       'Featured',
                //       style: TextStyle(
                //         fontSize: 12 * scale,
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),

            /// PRODUCT INFO
            Container(
              width: double.infinity,
              color: Colors.amber.shade400,
              padding: EdgeInsets.all(10 * scale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.fields.category,
                    style: TextStyle(
                      fontSize: 12 * scale,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 4 * scale),
                  Text(
                    product.fields.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14 * scale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6 * scale),
                  Text(
                    "Rp ${product.fields.price}",
                    style: TextStyle(
                      fontSize: 14 * scale,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
