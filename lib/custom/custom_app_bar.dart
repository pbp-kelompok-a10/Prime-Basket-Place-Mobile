import 'package:flutter/material.dart';
import 'package:prime_basket_place_mobile/account/screens/profile.dart';
import 'package:prime_basket_place_mobile/homepage/screens/homepage.dart';

class CustomShopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final Color primaryColor;

  const CustomShopAppBar({
    this.backgroundColor = const Color(0xFFE5E5E5),
    this.primaryColor = const Color(0xFF4C2FA0),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Homepage()),
                    );
                  },
                  child: Image.asset("logo_ball.png", height: 32),
                ),

                const SizedBox(width: 20),

                /// BRAND NAME
                Image.asset("title_brand.png", height: 32),

                const Spacer(),

                /// FAVORITE
                IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    color: primaryColor,
                    size: 30,
                  ),
                  onPressed: () {
                    // future: favorite page
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
