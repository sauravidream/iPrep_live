// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

class CategoryData {
  CategoryData({
    this.color,
    this.icon,
    this.index,
    this.name,
    this.id,
  });

  String? color;
  String? icon;
  int? index;
  String? name;
  String? id;

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
        color: json["color"],
        icon: json["icon"],
        index: json["index"],
        name: json["name"],
        id: json["id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "color": color,
        "icon": icon,
        "index": index,
        "name": name,
        "id": id,
      };
}

class CategoryId {
  CategoryId({this.categoryId});
  String? categoryId;

  factory CategoryId.fromJson(String json) => CategoryId(categoryId: json);
}

class Category {
  Category({this.id, this.categoryData});
  List<CategoryData>? categoryData;
  List<CategoryId>? id;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
      id: List<CategoryId>.from(json.keys.map((x) => CategoryId.fromJson(x))),
      categoryData: List<CategoryData>.from(
          json.values.map((x) => CategoryData.fromJson(x))));
}
