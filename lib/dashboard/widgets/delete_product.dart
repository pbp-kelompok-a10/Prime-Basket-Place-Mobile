import 'package:flutter/material.dart';

class DeleteProductDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteProductDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Hapus Produk"),
      content: const Text(
        "Apakah kamu yakin ingin menghapus produk ini? Tindakan ini tidak dapat dibatalkan.",
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: const Text("Hapus"),
        ),
      ],
    );
  }
}
