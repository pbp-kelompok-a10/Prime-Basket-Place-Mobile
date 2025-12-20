import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class ReviewFormDialog extends StatefulWidget {
  final Function(int rating, String comment, List<String>? images) onSubmit;

  const ReviewFormDialog({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<ReviewFormDialog> createState() => _ReviewFormDialogState();
}

class _ReviewFormDialogState extends State<ReviewFormDialog> {
  int selectedRating = 0;
  final TextEditingController commentController = TextEditingController();
  List<String> imageBase64List = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64Image = base64Encode(bytes);
        setState(() {
          imageBase64List.add(base64Image);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'What is you rate?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRating = index + 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      index < selectedRating ? Icons.star : Icons.star_border,
                      size: 48,
                      color: Colors.deepPurple,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            const Text(
              'Please Share Your Opinion',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: commentController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Your Review',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _pickImage,
                  icon: const Icon(
                    Icons.camera_alt,
                    size: 32,
                    color: Colors.deepPurple,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedRating == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a rating')),
                      );
                      return;
                    }
                    if (commentController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please write a review')),
                      );
                      return;
                    }
                    widget.onSubmit(
                      selectedRating,
                      commentController.text.trim(),
                      imageBase64List.isEmpty ? null : imageBase64List,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Send',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            if (imageBase64List.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('${imageBase64List.length} image(s) selected'),
            ],
          ],
        ),
      ),
    );
  }
}
