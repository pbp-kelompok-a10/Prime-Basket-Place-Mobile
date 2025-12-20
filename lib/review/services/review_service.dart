import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/review_model.dart';

class ReviewService {
  // Ganti dengan URL Django backend Anda
  static const String baseUrl = 'http://localhost:8000/api';

  // Get all reviews for a product
  static Future<List<Review>> getReviews(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$productId/reviews/'),
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
        Uri.parse('$baseUrl/products/$productId/reviews/stats/'),
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

  // Submit a new review
  static Future<bool> submitReview({
    required String productId,
    required int rating,
    required String comment,
    List<String>? imageBase64List,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products/$productId/reviews/'),
        headers: {
          'Content-Type': 'application/json',
          // Tambahkan authentication header jika diperlukan
          // 'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'rating': rating,
          'comment': comment,
          'images': imageBase64List ?? [],
        }),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      throw Exception('Error submitting review: $e');
    }
  }
}
