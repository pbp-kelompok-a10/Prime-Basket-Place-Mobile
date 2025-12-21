import 'package:flutter/material.dart';
import 'package:prime_basket_place_mobile/custom/custom_app_bar.dart';
import 'package:prime_basket_place_mobile/custom/custom_drawer.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
      appBar: const CustomShopAppBar(), // Menggunakan AppBar custom Anda
      drawer: const LeftDrawer(), // Menggunakan Drawer custom Anda
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'About This App',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Prime Basket Place merupakan sebuah aplikasi jual-beli yang dikhususkan untuk alat-alat olahraga basket.'
              ' Disini para pencinta basket bisadatang untuk mempersiapkan dirinya menjadi Pro Player Basketball.'
              ' Aplikasi ini menawarkan tempat untuk beragam alat-alat basket yang bisa dibeli ataupun dijual untuk pengguna'
              ' ditambah dengan adanya fitur ulasan dan detail yang bisa memudahkan untuk pengguna memilih alat yang kualitas bagus. ☆',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),

            Text(
              'Developer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Rafsanjani - 2406495400'),
            Text('Iqbal Rafi Nuryana - 2406417462'),
            Text('Farras Syafiq Ulumuddin - 2406495722'),
            Text('Z Arsy Alam Sin	- 2406495836'),
            Text('Michael Stephen Daniel Panjaitan - 2406496321'),

            SizedBox(height: 24),

            Text(
              'Version',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('v1.0.0'),
          ],
        ),
      ),
    );
  }
}
