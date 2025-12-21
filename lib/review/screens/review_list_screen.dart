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
  bool hasUserReviewed = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    try {
      final loadedReviews = await ReviewService.getReviews(widget.productId);
      final loadedStats = await ReviewService.getReviewStats(widget.productId);

      // Check if current user has already reviewed
      final request = context.read<CookieRequest>();
      if (request.loggedIn) {
        // Cek apakah ada review dari user ini
        hasUserReviewed = loadedReviews.any(
          (review) => review.userName == request.jsonData['username'],
        );
      }

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
    final request = context.read<CookieRequest>();

    if (!request.loggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to write a review'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (hasUserReviewed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have already reviewed this product'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => ReviewFormDialog(
        onSubmit: (rating, comment, images) async {
          try {
            final success = await ReviewService.submitReview(
              request: request, // Pass the authenticated request
              productId: widget.productId,
              rating: rating,
              comment: comment,
              imageBase64List: images,
            );

            if (success && mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Review submitted successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              _loadData(); // Reload reviews
            }
          } catch (e) {
            if (mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to submit review: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
      appBar: const CustomShopAppBar(), // Menggunakan AppBar custom Anda
      drawer: const LeftDrawer(), // Menggunakan Drawer custom Anda
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rating & Review - ${widget.productName}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rating Summary Box
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
                                    Icons.star,
                                    size: 60,
                                    color: Colors.amber,
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
                                    backgroundColor: hasUserReviewed
                                        ? Colors.grey
                                        : Colors.deepPurple,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    hasUserReviewed
                                        ? 'Already Reviewed'
                                        : 'Make Review',
                                    style: const TextStyle(
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
                        // Reviews List
                        Expanded(
                          child: reviews.isEmpty
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(32.0),
                                    child: Text(
                                      'No reviews yet. Be the first to review!',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                )
                              : Column(
                                  children: reviews.map((review) {
                                    return ReviewCard(review: review);
                                  }).toList(),
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
