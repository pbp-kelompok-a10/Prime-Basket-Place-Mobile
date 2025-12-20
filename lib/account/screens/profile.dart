import 'package:flutter/material.dart';
import 'package:prime_basket_place_mobile/custom/custom_app_bar.dart';
import 'package:prime_basket_place_mobile/custom/custom_drawer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: const CustomShopAppBar(),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        // Bungkus semua konten di dalam Column
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Agar teks "Account" sejajar kiri
          children: [
            // Tambahkan Teks "Account" dan Icon
            Padding(
              padding: const EdgeInsets.only(
                top: 80,
                left: 24,
                bottom: 20,
              ), // Sesuaikan padding
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color(0x3B522E9B),
                    ),
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.settings,
                      color: Color(0xFF522E9B),
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 19),
                  Container(
                    child: Text(
                      "Account",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF522E9B),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Container yang berisi form profil
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(30.0),
              // Sesuaikan margin. Top margin tidak diperlukan karena sudah ada Padding di atas
              margin: const EdgeInsets.only(left: 24, right: 24, bottom: 50),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar Circle
                  Container(
                    width: 162,
                    height: 162,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 70,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Upload Button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B3F72),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(120, 40),
                    ),
                    child: const Text(
                      "Edit",
                      style: TextStyle(fontSize: 15, color: Color(0xFFD9D6E1)),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Nickname
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Nickname",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4B3F72),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  TextField(
                    decoration: InputDecoration(
                      hintText: "Iqbal Rafi",
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
                  const SizedBox(height: 24),

                  // Umur
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Umur",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4B3F72),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "42",
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
                  const SizedBox(height: 32),

                  // Save Button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE5E5E5),
                      foregroundColor: const Color(0xFF522E9B),
                      elevation: 0,
                      side: const BorderSide(
                        color: Color(0xFF522E9B),
                        width: 1.4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      minimumSize: const Size(191, 50),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
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
}
