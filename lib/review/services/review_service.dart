import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/review_model.dart';

class ReviewService {
  static const String baseUrl =
      'https://rafsanjani41-primebasketplace.pbp.cs.ui.ac.id';

  // Get all reviews for a product
  static Future<List<Review>> getReviews(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reviews/json/$productId/'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Review.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get review statistics
  static Future<ReviewStats> getReviewStats(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reviews/json/$productId/stats/'),
      );

      if (response.statusCode == 200) {
        return ReviewStats.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load review stats');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Submit a new review WITH AUTHENTICATION
  static Future<bool> submitReview({
    required CookieRequest request, // Tambahkan parameter ini
    required String productId,
    required int rating,
    required String comment,
    List<String>? imageBase64List,
  }) async {
    try {
      final response = await request.postJson(
        '$baseUrl/reviews/create-flutter/$productId/',
        jsonEncode({
          'rating': rating,
          'comment': comment,
          'images': imageBase64List ?? [],
        }),
      );

      if (response['status'] == 'success') {
        return true;
      } else {
        throw Exception(response['message'] ?? 'Failed to submit review');
      }
    } catch (e) {
      throw Exception('Error submitting review: $e');
    }
  }
}
