import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class EditDescriptionForm extends StatefulWidget {
  final int productId;

  const EditDescriptionForm({super.key, required this.productId});

  @override
  State<EditDescriptionForm> createState() => _EditDescriptionFormState();
}

class _EditDescriptionFormState extends State<EditDescriptionForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Deskripsi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Deskripsi Baru",
                  hintText: "Masukkan deskripsi produk",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                maxLines: 5,
                enabled: !_isLoading,
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Deskripsi tidak boleh kosong!";
                  }
                  if (value.length < 10) {
                    return "Deskripsi minimal 10 karakter!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isLoading = true);
                            
                            try {
                              // Kirim data ke Django
                              final response = await request.postJson(
                                "https://rafsanjani41-primebasketplace.pbp.cs.ui.ac.id/detail/product/${widget.productId}/update-flutter/",
                                jsonEncode(<String, String>{
                                  'description': _descriptionController.text.trim(),
                                }),
                              );

                              if (!mounted) return;

                              if (response != null && response['status'] == 'success') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Deskripsi berhasil disimpan!"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pop(context); // Kembali ke halaman detail
                              } else {
                                final errorMessage = response?['message'] ?? 
                                    "Terdapat kesalahan, silakan coba lagi.";
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(errorMessage),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (!mounted) return;
                              
                              print('Error saat edit description: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Error: $e",
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } finally {
                              if (mounted) {
                                setState(() => _isLoading = false);
                              }
                            }
                          }
                        },
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          "Simpan",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
