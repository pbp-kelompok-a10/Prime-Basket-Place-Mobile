import 'package:flutter/material.dart';
import 'package:prime_basket_place_mobile/account/screens/login.dart';
import 'package:prime_basket_place_mobile/dashboard/screens/dashboard_screen.dart';
import 'package:prime_basket_place_mobile/homepage/screens/homepage.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => CookieRequest(),
      child: MaterialApp(
        title: 'Prime Basket Place',
        theme: ThemeData(primarySwatch: Colors.purple),
        home: const DashboardPage(),
      ),
    );
  }
}
