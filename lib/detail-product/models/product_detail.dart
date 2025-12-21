// To parse this JSON data, do
//
//     final productDetail = productDetailFromJson(jsonString);

import 'dart:convert';

List<ProductDetail> productDetailFromJson(String str) =>
    List<ProductDetail>.from(
      json.decode(str).map((x) => ProductDetail.fromJson(x)),
    );

String productDetailToJson(List<ProductDetail> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductDetail {
  String model;
  int pk;
  Fields fields;

  ProductDetail({required this.model, required this.pk, required this.fields});

  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
    model: json["model"],
    pk: json["pk"],
    fields: Fields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "model": model,
    "pk": pk,
    "fields": fields.toJson(),
  };
}

class Fields {
  String name;
  String brand;
  String category;
  int price;
  String imageUrl;
  String description;
  dynamic user;

  Fields({
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.user,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    name: json["name"],
    brand: json["brand"],
    category: json["category"],
    price: json["price"],
    imageUrl: json["image_url"],
    description: json["description"] ?? "",
    user: json["user"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "brand": brand,
    "category": category,
    "price": price,
    "image_url": imageUrl,
    "description": description,
    "user": user,
  };
}
