import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import '../models/review_model.dart';
import '../services/review_service.dart';
import '../widgets/review_card.dart';
import '../widgets/review_form_dialog.dart';
import 'package:prime_basket_place_mobile/custom/custom_app_bar.dart';
import 'package:prime_basket_place_mobile/custom/custom_drawer.dart';

class ReviewListScreen extends StatefulWidget {
  final String productId;
  final String productName;

  const ReviewListScreen({
    Key? key,
    required this.productId,
    required this.productName,
  }) : super(key: key);

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  List<Review> reviews = [];
  ReviewStats? stats;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final request = context.read<CookieRequest>();

    setState(() => isLoading = true);

    try {
      final loadedReviews = await ReviewService.getReviews(
        request: request,
        productId: widget.productId,
      );

      final loadedStats = await ReviewService.getReviewStats(
        request: request,
        productId: widget.productId,
      );

      setState(() {
        reviews = loadedReviews;
        stats = loadedStats;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        reviews = [];
        stats = ReviewStats(averageRating: 0.0, totalReviews: 0);
        isLoading = false;
      });
    }
  }

  void _showReviewDialog() {
    showDialog(
      context: context,
      builder: (context) => ReviewFormDialog(
        onSubmit: (rating, comment, images) async {
          final request = context.read<CookieRequest>();

          try {
            final success = await ReviewService.submitReview(
              request: request,
              productId: widget.productId,
              rating: rating,
              comment: comment,
            );

            if (success && mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Review submitted successfully!')),
              );
              _loadData();
            }
          } catch (e) {
            // fallback lokal (testing only)
            if (mounted) {
              Navigator.pop(context);
              setState(() {
                reviews.insert(
                  0,
                  Review(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    userName: 'You',
                    rating: rating,
                    comment: comment,
                    images: const [],
                    createdAt: DateTime.now(),
                  ),
                );

                stats = ReviewStats(
                  averageRating: _calculateNewAverage(rating),
                  totalReviews: reviews.length,
                );
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Review added (local testing mode)'),
                ),
              );
            }
          }
        },
      ),
    );
  }

  double _calculateNewAverage(int newRating) {
    if (reviews.isEmpty) return newRating.toDouble();
    final totalRating =
        reviews.fold<int>(0, (sum, review) => sum + review.rating) + newRating;
    return totalRating / (reviews.length + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: const CustomShopAppBar(),
      drawer: const LeftDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rating & Review',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Summary Box
                        Container(
                          width: 300,
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(60),
                                  border: Border.all(
                                    color: Colors.grey[400]!,
                                    width: 2,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.person_outline,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              Text(
                                stats?.averageRating.toStringAsFixed(1) ??
                                    '0.0',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${stats?.totalReviews ?? 0} ratings',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 32),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _showReviewDialog,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Make Review',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            children: reviews
                                .map((review) => ReviewCard(review: review))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
