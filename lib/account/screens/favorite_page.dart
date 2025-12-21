import 'package:flutter/material.dart';
import 'package:prime_basket_place_mobile/account/account_provider.dart';
import 'package:prime_basket_place_mobile/account/model/account_entry.dart';
import 'package:prime_basket_place_mobile/account/screens/login.dart';
import 'package:prime_basket_place_mobile/account/screens/password_page.dart';
import 'package:prime_basket_place_mobile/account/screens/profile.dart';
import 'package:prime_basket_place_mobile/custom/custom_app_bar.dart';
import 'package:prime_basket_place_mobile/account/screens/profile_drawer.dart';
import 'package:prime_basket_place_mobile/custom/custom_drawer.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final UserAccount? account = accountProvider.account;
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

      // Drawer kiri (menu utama)
      drawer: LeftDrawer(),

      // Drawer kanan (profile)
      endDrawer: ProfileDrawer(
        selectedIndex: 2,
        onItemSelected: (index) => handleProfileRouting(context, index),
      ),

      appBar: CustomShopAppBar(),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context, "Favourite"),
          Expanded(child: _gridContent()),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _header(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 80, left: 24, bottom: 20),
      child: Row(
        children: [
          Builder(
            builder: (scaffoldContext) {
              return InkWell(
                onTap: () {
                  // 👉 BUKA DRAWER KANAN
                  Scaffold.of(scaffoldContext).openEndDrawer();
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0x3B522E9B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.settings, color: Color(0xFF522E9B)),
                ),
              );
            },
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

  // ================= GRID =================
  Widget _gridContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 4,
        itemBuilder: (_, __) => _productCard(),
      ),
    );
  }

  Widget _productCard() {
    return Container(
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
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Product Name",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text("Brand", style: TextStyle(color: Colors.grey)),
                SizedBox(height: 6),
                Text(
                  "IDR 120.000",
                  style: TextStyle(
                    color: Color(0xFF522E9B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= ROUTING =================
  void handleProfileRouting(BuildContext context, int index) {
    Navigator.pop(context); // tutup endDrawer

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
        // sudah di FavoritePage
        break;
      case 3:
        Navigator.popUntil(context, (route) => route.isFirst);
        break;
    }
  }
}
