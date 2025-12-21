import 'package:flutter/material.dart';
import 'package:prime_basket_place_mobile/account/account_provider.dart';
import 'package:prime_basket_place_mobile/account/model/account_entry.dart';
import 'package:prime_basket_place_mobile/account/screens/manage_user.dart';
import 'package:provider/provider.dart';

class ProfileDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const ProfileDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Optimization: Use select to only rebuild when the account changes, not the whole provider
    final UserAccount? account = context.watch<AccountProvider>().account;

    // BLIND SPOT: Returning a Scaffold inside a Drawer is a UI bug.
    // If not logged in, show an empty drawer or a login prompt, don't hijack the screen.
    if (account == null) {
      return const Drawer(child: Center(child: Text("Please log in")));
    }

    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 16, bottom: 12),
                child: Text(
                  "Account",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),

              _item(context, Icons.person, "Profile Settings", 0),
              _item(context, Icons.lock, "Password", 1),
              _item(context, Icons.favorite, "Favorite", 2),
              _item(
                context,
                Icons.power_settings_new,
                "Logout",
                3,
                onTap: () async {
                  if (!context.mounted) return;

                  // 1Tutup drawer dulu
                  Navigator.pop(context);

                  // Pindah ke halaman awal / login
                  Navigator.popUntil(context, (route) => route.isFirst);

                  // BARU logout (set account = null)
                  await context.read<AccountProvider>().logout();
                },
              ),

              if (account.fields.roles == "Admin") ...[
                const Divider(height: 32),
                _item(
                  context,
                  Icons.group,
                  "Manage Users",
                  4,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageUserPage(),
                      ),
                    );
                  },
                ),
              ],

              const Spacer(),
              const Divider(),
              _item(
                context,
                Icons.delete,
                "Delete Account",
                6,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String text,
    int index, {
    Color? color,
    VoidCallback? onTap,
  }) {
    final bool isSelected = index == selectedIndex;
    final Color effectiveColor = color ?? Colors.black87;

    return ListTile(
      selected: isSelected,
      selectedTileColor: Colors.deepPurple.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Icon(
        icon,
        color: isSelected ? Colors.deepPurple : effectiveColor,
      ),
      title: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.deepPurple : effectiveColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap ?? () => onItemSelected(index),
    );
  }
}
