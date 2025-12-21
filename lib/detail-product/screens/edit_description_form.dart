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
  String _description = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
      appBar: AppBar(title: const Text('Edit Deskripsi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Deskripsi Baru",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                maxLines: 5,
                onChanged: (String? value) {
                  setState(() {
                    _description = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Deskripsi tidak boleh kosong!";
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Kirim data ke Django
                      final response = await request.postJson(
                        "https://rafsanjani41-primebasketplace.pbp.cs.ui.ac.id/detail/edit-flutter/${widget.productId}/update-flutter/",
                        jsonEncode(<String, String>{
                          'description': _description,
                        }),
                      );

                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Deskripsi berhasil disimpan!"),
                          ),
                        );
                        Navigator.pop(context); // Kembali ke halaman detail
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Terdapat kesalahan, silakan coba lagi.",
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text(
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
