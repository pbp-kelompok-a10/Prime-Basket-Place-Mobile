import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:prime_basket_place_mobile/account/account_provider.dart';
import 'package:prime_basket_place_mobile/account/model/account_entry.dart';
import 'package:prime_basket_place_mobile/account/screens/login.dart';
import 'package:prime_basket_place_mobile/account/screens/password_page.dart';
import 'package:prime_basket_place_mobile/account/screens/profile.dart';
import 'package:prime_basket_place_mobile/account/screens/profile_drawer.dart';
import 'package:prime_basket_place_mobile/custom/custom_app_bar.dart';
import 'package:prime_basket_place_mobile/custom/custom_drawer.dart';
import 'package:prime_basket_place_mobile/detail-product/screens/product_detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  // ================= FETCH & FILTER LOGIC =================
  Future<List<dynamic>> fetchFavorites(
    CookieRequest request,
    List<int> userFavoriteIds,
  ) async {
    const String baseUrl =
        "https://rafsanjani41-primebasketplace.pbp.cs.ui.ac.id";

    // 1. Ambil SEMUA data produk
    final response = await request.get('$baseUrl/json/');

    // 2. Filter data: Hanya ambil jika ID produk (pk) ada di list favorit user
    List<dynamic> listFavorites = [];
    for (var d in response) {
      if (d != null) {
        int productId = d['pk'];
        // Cek apakah ID produk ini ada di daftar favorit user?
        if (userFavoriteIds.contains(productId)) {
          listFavorites.add(d);
        }
      }
    }
    return listFavorites;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final accountProvider = context.watch<AccountProvider>();
    final UserAccount? account = accountProvider.account;

    // Redirect jika tidak login
    if (account == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: CustomShopAppBar(),
      drawer: const LeftDrawer(),
      endDrawer: ProfileDrawer(
        selectedIndex: 2,
        onItemSelected: (index) => handleProfileRouting(context, index),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context, "Favourite"),

          Expanded(
            child: FutureBuilder(
              // Kirim request DAN list ID favorit user ke fungsi fetch
              future: fetchFavorites(request, account.fields.favorites),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No favorite items yet.",
                        style: TextStyle(
                          color: Color(0xff59A5D8),
                          fontSize: 18,
                        ),
                      ),
                    );
                  } else {
                    // Tampilkan Grid Produk
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.72,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) =>
                          _productCard(snapshot.data![index]),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= PRODUCT CARD =================
  Widget _productCard(dynamic product) {
    // Ambil ID produk (pk) untuk dikirim ke halaman detail
    final int pk = product['pk'];

    // Ambil fields
    final fields = product['fields'];
    final String name = fields['name'];
    final String brand = fields['brand'];
    final int price = fields['price'];
    final String imageUrl = fields['image_url'] ?? "";

    // BUNGKUS DENGAN INKWELL ATAU GESTUREDETECTOR
    return InkWell(
      onTap: () {
        // Logika Routing ke ProductDetailPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(productId: pk),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Gambar
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (ctx, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                  errorBuilder: (ctx, error, stack) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Bagian Teks
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    brand,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "IDR $price",
                    style: const TextStyle(
                      color: Color(0xFF522E9B),
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

  // ================= HEADER UI =================
  Widget _header(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 80, left: 24, bottom: 20),
      child: Row(
        children: [
          InkWell(
            onTap: () => Scaffold.of(context).openEndDrawer(),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0x3B522E9B),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.settings, color: Color(0xFF522E9B)),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Color(0xFF522E9B),
            ),
          ),
        ],
      ),
    );
  }

  // ================= ROUTING LOGIC =================
  void handleProfileRouting(BuildContext context, int index) {
    Navigator.pop(context); // Tutup drawer

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfilePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PasswordPage()),
        );
        break;
      case 2:
        break; // Sudah di halaman ini
      case 3:
        Navigator.popUntil(context, (route) => route.isFirst);
        break;
    }
  }
}
