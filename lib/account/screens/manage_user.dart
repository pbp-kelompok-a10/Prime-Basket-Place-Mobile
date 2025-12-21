import 'package:flutter/material.dart';
import 'package:prime_basket_place_mobile/account/screens/favorite_page.dart';
import 'package:prime_basket_place_mobile/account/screens/password_page.dart';
import 'package:prime_basket_place_mobile/account/screens/profile.dart';
import 'package:prime_basket_place_mobile/account/screens/profile_drawer.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:prime_basket_place_mobile/custom/custom_app_bar.dart';
import 'package:prime_basket_place_mobile/custom/custom_drawer.dart';

class ManageUserPage extends StatefulWidget {
  const ManageUserPage({super.key});

  static const String baseUrl = "https://rafsanjani41-primebasketplace.pbp.cs.ui.ac.id/";

  @override
  State<ManageUserPage> createState() => _ManageUserPageState();
}

class _ManageUserPageState extends State<ManageUserPage> {
  // ================= FETCH ACCOUNT JSON =================
  Future<List<dynamic>> fetchAccounts(CookieRequest request) async {
    final response = await request.get(
      "${ManageUserPage.baseUrl}account/json/",
    );
    return List<dynamic>.from(response);
  }

  // ================= UPDATE ROLE =================
  Future<void> updateRole({
    required CookieRequest request,
    required int userId,
    required bool makeAdmin,
    required BuildContext context,
  }) async {
    final endpoint = makeAdmin ? "auth/make-admin/" : "auth/remove-admin/";

    final response = await request.post("${ManageUserPage.baseUrl}$endpoint", {
      "user_id": userId.toString(),
    });

    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(response["message"] ?? "Action done")),
      );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: CustomShopAppBar(
        onLogoTap: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      ),
      drawer: const LeftDrawer(),
      endDrawer: ProfileDrawer(
        selectedIndex: 0,
        onItemSelected: (index) {
          handleProfileRouting(context, index);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildHeader(context), _buildUsersList(request)],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80, left: 24, bottom: 20),
      child: Row(
        children: [
          Builder(
            builder: (context) {
              return InkWell(
                onTap: () => Scaffold.of(context).openEndDrawer(),
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0x3B522E9B),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(
                    Icons.settings,
                    size: 20,
                    color: Color(0xFF522E9B),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          const Text(
            "Manage Users",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF522E9B),
            ),
          ),
        ],
      ),
    );
  }

  // ================= USERS LIST =================
  Widget _buildUsersList(CookieRequest request) {
    return FutureBuilder<List<dynamic>>(
      future: fetchAccounts(request),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No users found"));
        }

        final accounts = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 50),
          child: Column(
            children: List.generate(
              accounts.length,
              (index) => _buildUserCard(accounts[index], request),
            ),
          ),
        );
      },
    );
  }

  // ================= USER CARD =================
  Widget _buildUserCard(dynamic acc, CookieRequest request) {
    // 1. EXTRACT DATA
    final fields = acc["fields"];
    final int userId = fields["user"];
    final String role = fields["roles"] ?? "User";
    final String nickname = (fields["nickname"] ?? "").toString();
    // Trim URL to remove accidental spaces that cause crashes
    final String profilePicture = (fields["profile_picture"] ?? "")
        .toString()
        .trim();

    final bool isAdmin = role == "Admin";

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            // Changed to standard withOpacity for compatibility
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: SizedBox(
          width: 52,
          height: 52,
          child: ClipOval(
            // 2. DEFENSIVE IMAGE LOADING (The Fix)
            child: profilePicture.isNotEmpty
                ? Image.network(
                    profilePicture,
                    fit: BoxFit.cover,
                    // If image loads, show it
                    loadingBuilder: (ctx, child, progress) {
                      if (progress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                    // If image FAILS (Status 0, 404, etc), show icon instead of crashing
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      );
                    },
                  )
                : Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.person, color: Colors.grey),
                  ),
          ),
        ),
        title: Text(
          nickname.isNotEmpty ? nickname : "User ID $userId",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "Role: $role",
          style: TextStyle(
            color: isAdmin ? Colors.green : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isAdmin ? Colors.red : const Color(0xFF522E9B),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            await updateRole(
              request: request,
              userId: userId,
              makeAdmin: !isAdmin,
              context: context,
            );

            if (!context.mounted) return;
            setState(() {});
          },
          child: Text(
            isAdmin ? "Remove Admin" : "Make Admin",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // ================= ROUTING =================
  void handleProfileRouting(BuildContext context, int index) {
    Navigator.pop(context);

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const FavoritePage()),
        );
        break;
      case 3:
        Navigator.popUntil(context, (route) => route.isFirst);
        break;
    }
  }
}
