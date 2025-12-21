import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prime_basket_place_mobile/custom/custom_app_bar.dart';
import 'package:prime_basket_place_mobile/custom/custom_drawer.dart';
import 'package:prime_basket_place_mobile/dashboard/screens/dashboard_screen.dart';
import 'package:prime_basket_place_mobile/models/product.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class AddProductFormPage extends StatefulWidget {
  final Product? product; // null = ADD, ada = EDIT

  const AddProductFormPage({super.key, this.product});

  @override
  State<AddProductFormPage> createState() => _AddProductFormPageState();
}

class _AddProductFormPageState extends State<AddProductFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _priceController;
  late TextEditingController _thumbnailController;
  late TextEditingController _descriptionController;

  String _category = "Other";

  final List<String> _categories = [
    'Jersey',
    'Shorts',
    'Hoodie/Sweatshirt',
    'Pants/Tracksuit',
    'Top/T-Shirt',
    'Other',
  ];

  bool get isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();

    final p = widget.product;

    _nameController = TextEditingController(text: p?.fields.name ?? "");
    _brandController = TextEditingController(text: p?.fields.brand ?? "");
    _priceController = TextEditingController(
      text: p?.fields.price.toString() ?? "",
    );
    _thumbnailController = TextEditingController(
      text: p?.fields.imageUrl ?? "",
    );
    _descriptionController = TextEditingController(
      text: p?.fields.description ?? "",
    );

    _category = p?.fields.category ?? "Other";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _thumbnailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: const CustomShopAppBar(),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== TITLE =====
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  isEdit ? "EDIT PRODUCT" : "ADD PRODUCT",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4C2FA0),
                  ),
                ),
              ),

              // ===== NAME =====
              _buildTextField(
                controller: _nameController,
                label: "Product Name",
                hint: "Enter product name",
                validator: (v) =>
                    v == null || v.isEmpty ? "Name cannot be empty" : null,
              ),

              // ===== BRAND =====
              _buildTextField(
                controller: _brandController,
                label: "Brand",
                hint: "Enter brand name",
                validator: (v) =>
                    v == null || v.isEmpty ? "Brand cannot be empty" : null,
              ),

              // ===== CATEGORY =====
              Padding(
                padding: const EdgeInsets.all(8),
                child: DropdownButtonFormField<String>(
                  value: _category,
                  decoration: _inputDecoration("Category"),
                  items: _categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _category = value!);
                  },
                ),
              ),

              // ===== PRICE =====
              _buildTextField(
                controller: _priceController,
                label: "Price",
                hint: "Enter price",
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) =>
                    v == null || v.isEmpty ? "Price required" : null,
              ),

              // ===== THUMBNAIL =====
              _buildTextField(
                controller: _thumbnailController,
                label: "Thumbnail URL",
                hint: "Optional image URL",
                validator: (v) {
                  if (v == null || v.isEmpty) return null;
                  final uri = Uri.tryParse(v);
                  return (uri == null || !uri.isAbsolute)
                      ? "Invalid URL"
                      : null;
                },
              ),

              // ===== DESCRIPTION =====
              _buildTextField(
                controller: _descriptionController,
                label: "Description",
                hint: "Add product description",
                maxLines: 5,
              ),

              // ===== SAVE BUTTON =====
              Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4C2FA0),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    final data = {
                      "name": _nameController.text,
                      "brand": _brandController.text,
                      "category": _category,
                      "price": double.parse(_priceController.text),
                      "image_url": _thumbnailController.text,
                      "description": _descriptionController.text,
                    };

                    final response = isEdit
                        ? await request.postJson(
                            "http://localhost:8000/dashboard/update-product/${widget.product!.pk}/",
                            jsonEncode({"fields": data}),
                          )
                        : await request.postJson(
                            "http://localhost:8000/dashboard/create-product-flutter/",
                            jsonEncode({"fields": data}),
                          );

                    if (!context.mounted) return;

                    if (response['status'] == 'success') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isEdit
                                ? "Product updated successfully!"
                                : "Product added successfully!",
                          ),
                        ),
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DashboardPage(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            response['message'] ?? "Something went wrong",
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    isEdit ? "Update" : "Save",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== HELPER =====
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: _inputDecoration(label, hint: hint),
        validator: validator,
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
    );
  }
}
