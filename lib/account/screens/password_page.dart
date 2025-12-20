import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:prime_basket_place_mobile/account/account_provider.dart';
import 'package:prime_basket_place_mobile/account/model/account_entry.dart';
import 'package:prime_basket_place_mobile/account/screens/favorite_page.dart';
import 'package:prime_basket_place_mobile/account/screens/login.dart';
import 'package:prime_basket_place_mobile/account/screens/profile.dart';
import 'package:prime_basket_place_mobile/custom/custom_app_bar.dart';
import 'package:prime_basket_place_mobile/account/screens/profile_drawer.dart';
import 'package:prime_basket_place_mobile/custom/custom_drawer.dart';
import 'package:provider/provider.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final accountProvider = context.read<AccountProvider>();
    if (accountProvider.account != null) {
      _usernameController.text = accountProvider.account!.fields.user
          .toString();
    }
  }

  Future<void> _saveChanges(CookieRequest request) async {
    setState(() => _isLoading = true);
    const String baseUrl = "https://rafsanjani41-primebasketplace.pbp.cs.ui.ac.id";

    try {
      final response = await request.post("$baseUrl/auth/change-password/", {
        "current_password": _currentPassController.text,
        "new_password": _newPassController.text,
        "confirm_password": _confirmPassController.text,
      });

      if (!mounted) return;

      if (response['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: Colors.green,
          ),
        );
        _currentPassController.clear();
        _newPassController.clear();
        _confirmPassController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? "Gagal"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
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
        selectedIndex: 1,
        onItemSelected: (index) => handleProfileRouting(context, index),
      ),
      appBar: CustomShopAppBar(
        onLogoTap: () => Navigator.popUntil(context, (route) => route.isFirst),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context, "Password"),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _textField("Username", _usernameController, isReadOnly: true),
                  const SizedBox(height: 16),
                  _textField(
                    "Current Password",
                    _currentPassController,
                    obscure: true,
                  ),
                  const SizedBox(height: 16),
                  _textField("New Password", _newPassController, obscure: true),
                  const SizedBox(height: 16),
                  _textField(
                    "Confirm New Password",
                    _confirmPassController,
                    obscure: true,
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: _isLoading ? null : () => _saveChanges(request),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF522E9B),
                      disabledBackgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Save Changes",
                            style: TextStyle(fontSize: 16, color: Colors.white),
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

  Widget _header(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 80, left: 24, bottom: 20),
      child: Row(
        children: [
          Builder(
            builder: (scaffoldContext) {
              return InkWell(
                onTap: () => Scaffold.of(scaffoldContext).openEndDrawer(),
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

  Widget _textField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
    bool isReadOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4B3F72),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          readOnly: isReadOnly,
          enableInteractiveSelection: !isReadOnly,
          decoration: InputDecoration(
            filled: true,
            fillColor: isReadOnly ? Colors.grey.shade200 : Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}

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
