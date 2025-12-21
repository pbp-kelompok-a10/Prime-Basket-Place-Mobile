import 'package:flutter/material.dart';
import 'package:prime_basket_place_mobile/account/screens/login.dart';
import 'package:provider/provider.dart';
import 'package:prime_basket_place_mobile/custom/custom_app_bar.dart';
import 'package:prime_basket_place_mobile/custom/custom_drawer.dart';

import 'package:prime_basket_place_mobile/account/screens/profile_drawer.dart';
import 'package:prime_basket_place_mobile/account/screens/favorite_page.dart';
import 'package:prime_basket_place_mobile/account/screens/password_page.dart';

import 'package:prime_basket_place_mobile/account/account_provider.dart';
import 'package:prime_basket_place_mobile/account/model/account_entry.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController nicknameController;
  late TextEditingController ageController;

  @override
  void initState() {
    super.initState();

    final account = Provider.of<AccountProvider>(
      context,
      listen: false,
    ).account;

    nicknameController = TextEditingController(
      text: account?.fields.nickname ?? '',
    );
    ageController = TextEditingController(
      text: account?.fields.age?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    nicknameController.dispose();
    ageController.dispose();
    super.dispose();
  }

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
      drawer: const LeftDrawer(),
      endDrawer: ProfileDrawer(
        selectedIndex: 0,
        onItemSelected: (index) {
          handleProfileRouting(context, index);
        },
      ),
      appBar: CustomShopAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildHeader(context), _buildProfileCard(account)],
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
            "Account",
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

  // ================= PROFILE CARD =================
  Widget _buildProfileCard(UserAccount account) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 50),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildAvatar(account),
          const SizedBox(height: 16),
          _buildEditButton(),
          const SizedBox(height: 32),
          _buildInput(label: "Nickname", controller: nicknameController),
          const SizedBox(height: 24),
          _buildInput(label: "Umur", controller: ageController, isNumber: true),
          const SizedBox(height: 32),
          _buildSaveButton(),
        ],
      ),
    );
  }

  // ================= AVATAR =================
  Widget _buildAvatar(UserAccount account) {
    final imageUrl = account.fields.profilePicture;

    final proxyUrl = (imageUrl != null && imageUrl.isNotEmpty)
        ? 'http://localhost:8000/proxy-image/?url=${Uri.encodeComponent(imageUrl)}'
        : null;

    return Container(
      width: 162,
      height: 162,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade200,
      ),
      child: ClipOval(
        child: proxyUrl == null
            ? const Icon(Icons.person, size: 70, color: Colors.grey)
            : Image.network(
                proxyUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.person, size: 70, color: Colors.grey),
              ),
      ),
    );
  }

  // ================= INPUT =================
  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF4B3F72),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFF4B3F72),
                width: 1.3,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================= BUTTON =================
  Widget _buildEditButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4B3F72),
        minimumSize: const Size(120, 40),
      ),
      child: const Text("Edit", style: TextStyle(color: Color(0xFFD9D6E1))),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () {
        // TODO: call API save profile
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE5E5E5),
        foregroundColor: const Color(0xFF522E9B),
        elevation: 0,
        side: const BorderSide(color: Color(0xFF522E9B), width: 1.4),
        minimumSize: const Size(191, 50),
      ),
      child: const Text("Save"),
    );
  }
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
