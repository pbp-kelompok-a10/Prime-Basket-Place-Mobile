import 'package:flutter/material.dart';
import 'package:prime_basket_place_mobile/account/screens/profile.dart';
import 'package:prime_basket_place_mobile/homepage/screens/homepage.dart';
import 'package:prime_basket_place_mobile/account/screens/favorite_page.dart';

class CustomShopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final Color primaryColor;
  // 1. Tambahkan variabel callback ini
  final VoidCallback? onLogoTap;

  const CustomShopAppBar({
    this.backgroundColor = const Color(0xFFE5E5E5),
    this.primaryColor = const Color(0xFF4C2FA0),
    // 2. Tambahkan parameter ini di constructor
    this.onLogoTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                /// MENU BTN
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Builder(
                    builder: (ctx) {
                      return GestureDetector(
                        onTap: () => Scaffold.of(ctx).openDrawer(),
                        child: Icon(Icons.menu, color: primaryColor, size: 32),
                      );
                    },
                  ),
                ),

                /// BASKET LOGO
                GestureDetector(
                  // 3. Ubah bagian ini agar menggunakan onLogoTap jika ada
                  onTap:
                      onLogoTap ??
                      () {
                        // Default action jika onLogoTap tidak diisi
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Homepage()),
                        );
                      },
                  child: Image.asset(
                    "assets/logo_ball.png",
                    height: 32,
                  ), // Pastikan path asset benar
                ),

                const SizedBox(width: 20),

                /// BRAND NAME
                Image.asset(
                  "assets/title_brand.png",
                  height: 32,
                ), // Pastikan path asset benar

                const Spacer(),

                /// FAVORITE
                IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    color: primaryColor,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FavoritePage()),
                    );
                  },
                ),

                /// PROFILE
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: IconButton(
                    icon: Icon(
                      Icons.person_outline,
                      color: primaryColor,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfilePage()),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// BOTTOM DIVIDER
            Divider(height: 1, thickness: 2, color: primaryColor),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
