import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prime_basket_place_mobile/account/model/account_entry.dart';

class AccountProvider extends ChangeNotifier {
  UserAccount? account;

  final String baseUrl = 'http://localhost:8000';

  Future<bool> logout() async {
    final url = Uri.parse('$baseUrl/auth/logout/');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      account = null;
      notifyListeners();
      return true;
    }

    return false;
  }
   void setAccount(UserAccount account) {
    this.account = account;
    notifyListeners();
  }

}

