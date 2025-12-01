import 'package:flutter/material.dart';

class CustomShopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onLogoTap;
  final Function(String)? onSearchChanged;
  final Function(String)? onSearchSubmit;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onProfileTap;

  final String? initialSearch;
  final Color backgroundColor;
  final Color primaryColor;

  const CustomShopAppBar({
    this.onMenuTap,
    this.onLogoTap,
    this.onSearchChanged,
    this.onFavoriteTap,
    this.onProfileTap,
    this.onSearchSubmit,
    this.initialSearch,
    this.backgroundColor = const Color(0xFFE5E5E5),
    this.primaryColor = const Color(0xFF4C2FA0),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// MENU BTN
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ), // ⬅️ geser ke kanan
          child: GestureDetector(
            onTap: onMenuTap,
            child: Icon(Icons.menu, color: primaryColor, size: 32),
          ),
        ),

        /// BASKET LOGO
        GestureDetector(
          onTap: onLogoTap,
          child: Image.asset("logo_ball.png", height: 32, fit: BoxFit.contain),
        ),
        const SizedBox(width: 20),

        /// BRAND NAME
        Column(
          children: [
            const SizedBox(height: 18),
            Image.asset(
              "title_brand.png",
              height: 32, // adjust to your UI
              fit: BoxFit.contain,
            ),
          ],
        ),
        const SizedBox(width: 20),

        Spacer(),

        // nanti ubah ke != null pas udah ada fungsinya.

        /// FAVORITE (optional)
        if (onFavoriteTap == null)
          GestureDetector(
            onTap: onFavoriteTap,
            child: Icon(Icons.favorite_border, color: primaryColor, size: 30),
          ),

        if (onFavoriteTap == null) const SizedBox(width: 24),

        /// PROFILE (optional)
        if (onProfileTap == null)
          Padding(
            padding: const EdgeInsets.only(right: 20), // ⬅️ geser kiri
            child: GestureDetector(
              onTap: onProfileTap,
              child: Icon(Icons.person_outline, color: primaryColor, size: 30),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
