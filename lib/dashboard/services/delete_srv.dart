import 'package:pbp_django_auth/pbp_django_auth.dart';

class ProductService {
  static Future<Map<String, dynamic>> deleteProduct(
    CookieRequest request,
    int productId,
  ) async {
    final response = await request.postJson(
      "https://rafsanjani41-primebasketplace.pbp.cs.ui.ac.id/dashboard/delete-product/$productId/",
      null,
    );

    return response;
  }
}
