import 'package:flutter/material.dart';
import 'package:prime_basket_place_mobile/dashboard/screens/dashboard_screen.dart';
import 'package:prime_basket_place_mobile/homepage/screens/homepage.dart';
import 'package:prime_basket_place_mobile/account/screens/profile.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(0),
        bottomRight: Radius.circular(30),
      ),
      child: Drawer(
        width: 290,
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 20,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF6A1B9A), // Purple seperti desain
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Prime Basket Place",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "We Ball!",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ================= MENU LIST =================
              _DrawerItem(
                icon: Icons.home_outlined,
                label: "Home",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Homepage()),
                  );
                },
              ),
              _DrawerItem(
                icon: Icons.person_outline,
                label: "Profile",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilePage()),
                  );
                },
              ),
              _DrawerItem(
                icon: Icons.view_in_ar_outlined,
                label: "Dashboard",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DashboardPage()),
                  );
                },
              ),
              _DrawerItem(
                icon: Icons.add_circle_outline,
                label: "Add Product",
                onTap: () => _goTo(context),
              ),
              _DrawerItem(
                icon: Icons.info_outline,
                label: "About Us",
                onTap: () => _goTo(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Temporary navigation (replace later)
  void _goTo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (c) => const PlaceholderPage()),
    );
  }
}

// =======================================================
// Drawer Item Widget
// =======================================================
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6A1B9A), size: 28),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF6A1B9A),
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      horizontalTitleGap: 10,
      minVerticalPadding: 12,
    );
  }
}

// =======================================================
// Placeholder Page (sementara, supaya tidak error nav)
// =======================================================
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Page")),
      body: const Center(child: Text("This page is not implemented yet.")),
    );
  }
}
