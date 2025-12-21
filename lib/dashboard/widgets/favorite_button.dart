import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class FavoriteButton extends StatefulWidget {
  final int productId;
  final bool initialFavorite;

  const FavoriteButton({
    Key? key,
    required this.productId,
    required this.initialFavorite,
  }) : super(key: key);

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.initialFavorite;
  }

  Future<void> _toggleFavorite() async {
    final request = context.read<CookieRequest>();

    try {
      final response = await request.postJson(
        'http://localhost:8000/dashboard/toggle-favorite/${widget.productId}/',
        {},
      );

      if (response['status'] == 'success') {
        setState(() {
          isFavorite = response['favorite'];
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response['message'])));
      } else {
        throw Exception(response['message'] ?? 'Failed to toggle favorite');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _toggleFavorite,
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Colors.white,
      ),
      label: Text(isFavorite ? 'Favorited' : 'Add to Favorite'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}
