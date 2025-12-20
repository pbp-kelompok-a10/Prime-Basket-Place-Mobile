import 'package:flutter/material.dart';
import 'package:prime_basket_place_mobile/account/screens/login.dart';
import 'package:prime_basket_place_mobile/dashboard/screens/dashboard_screen.dart';
import 'package:prime_basket_place_mobile/homepage/screens/homepage.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:prime_basket_place_mobile/account/account_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => CookieRequest()),
        ChangeNotifierProvider(create: (_) => AccountProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Prime Basket Place',
        theme: ThemeData(primarySwatch: Colors.purple),
        home: const DashboardPage(),
      ),
    );
  }
}
