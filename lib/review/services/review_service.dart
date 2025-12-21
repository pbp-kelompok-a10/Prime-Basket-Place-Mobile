import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/review_model.dart';

class ReviewService {
  static const String baseUrl = 'http://localhost:8000';

  /// =========================
  /// GET REVIEWS (PUBLIC)
  /// =========================
  static Future<List<Review>> getReviews({
    required CookieRequest request,
    required String productId,
  }) async {
    final response = await request.get('$baseUrl/reviews/json/$productId/');

    return (response as List).map((json) => Review.fromJson(json)).toList();
  }

  /// =========================
  /// GET REVIEW STATS (PUBLIC)
  /// =========================
  static Future<ReviewStats> getReviewStats({
    required CookieRequest request,
    required String productId,
  }) async {
    final response = await request.get(
      '$baseUrl/reviews/json/$productId/stats/',
    );

    return ReviewStats.fromJson(response);
  }

  /// =========================
  /// SUBMIT REVIEW (AUTH REQUIRED)
  /// =========================
  static Future<bool> submitReview({
    required CookieRequest request,
    required String productId,
    required int rating,
    required String comment,
  }) async {
    final response = await request.postJson(
      '$baseUrl/reviews/create-flutter/$productId/',
      {'rating': rating, 'comment': comment},
    );

    if (response['status'] == 'success') {
      return true;
    } else {
      throw Exception(response['message'] ?? 'Failed to submit review');
    }
  }
}
