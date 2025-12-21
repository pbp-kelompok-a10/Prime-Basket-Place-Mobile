import 'package:pbp_django_auth/pbp_django_auth.dart';

class ProductService {
  static Future<Map<String, dynamic>> deleteProduct(
    CookieRequest request,
    int productId,
  ) async {
    final response = await request.postJson(
      "http://localhost:8000/dashboard/delete-product/$productId/",
      null,
    );

    return response;
  }
}
