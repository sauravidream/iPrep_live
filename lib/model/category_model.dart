// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
    this.category,
  });

  List<Category>? category;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        category:
            List<Category>.from(json["math"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "category": List<dynamic>.from(category!.map((x) => x.toJson())),
      };
}

class Category {
  Category({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
