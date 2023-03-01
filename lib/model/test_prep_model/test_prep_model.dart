import 'dart:convert';

import 'package:encrypt/encrypt.dart';

List<AllExamModel> allExamModelFromJson(String str) => List<AllExamModel>.from(
    json.decode(str).map((x) => AllExamModel.fromJson(x)));

//List<AllExamModel>productsModelFromJson(str)=>List<AllExamModel>.from( str.map((x)=>AllExamModel.fromJson(x)).toList(),);

class AllExamModel {
  AllExamModel({
    this.allExam,
  });

  List<Others?>? allExam;

  factory AllExamModel.fromJson(Map<String, dynamic> json) => AllExamModel(
      allExam: List<Others?>.from(
          json.values.map((x) => x == null ? null : Others.fromJson(x))));
}

class Others {
  Others({
    this.href,
    this.icon,
    this.id,
    this.name,
    this.subCategory,
  });

  String? href;
  String? icon;
  String? id;
  String? name;
  List<SubCategory?>? subCategory;

//   Others.fromJSON(Map<String, dynamic> json) :
//         href = json['href'],
//         icon = json['icon'],
//         id = json['id'],
//         name = json['name'] ?? "",
//         subCategory = json['subCategory'] != null ? List<SubCategory?>.from(
//             (json['subCategory'] is Map) ? (json['subCategory'] as Map).values.map((el) => SubCategory.fromJson(el))
//                 : (json['subCategory'] as List).map((el) => el != null ? SubCategory.fromJson(el) : null)
//         ) : [];
//
  factory Others.fromJson(Map<String, dynamic> json) {
    return Others(
      href: json["href"] ?? "",
      icon: json["icon"] ?? "",
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      subCategory: json['subCategory'] != null
          ? List<SubCategory?>.from((json['subCategory'] is Map)
              ? (json['subCategory'] as Map)
                  .values
                  .map((el) => SubCategory.fromJson(el))
              : (json['subCategory'] as List)
                  .map((el) => el != null ? SubCategory.fromJson(el) : null))
          : [],
    );
  }
}

class SubCategory {
  SubCategory({
    this.category,
    this.categoryId,
    this.href,
    this.icon,
    this.id,
    this.name,
  });

  String? category;
  String? categoryId;
  String? href;
  String? icon;
  String? id;
  String? name;

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        category: json["category"] ?? "",
        categoryId: json["category_id"] ?? "",
        href: json["href"] ?? "",
        icon: json["icon"] ?? "",
        id: json["id"] ?? "",
        name: json["name"] ?? "",
      );
}
