// To parse this JSON data, do
//
//     final subCategory = subCategoryFromJson(jsonString);

import 'dart:convert';

SubCategory subCategoryFromJson(String str) =>
    SubCategory.fromJson(json.decode(str));

String subCategoryToJson(SubCategory data) => json.encode(data.toJson());

class SubCategory {
  SubCategory({
    this.categoryId,
  });

  CategoryId? categoryId;

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        categoryId: CategoryId.fromJson(json["category_id"]),
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId?.toJson(),
      };
}

class CategoryId {
  CategoryId({
    this.details,
    this.subcategories,
  });

  Details? details;
  Subcategories? subcategories;

  factory CategoryId.fromJson(Map<String, dynamic> json) => CategoryId(
        details: Details.fromJson(json["details"]),
        subcategories: Subcategories.fromJson(json["subcategories"]),
      );

  Map<String, dynamic> toJson() => {
        "details": details?.toJson(),
        "subcategories": subcategories?.toJson(),
      };
}

class Details {
  Details({
    this.color,
    this.icon,
    this.index,
    this.name,
  });

  String? color;
  String? icon;
  int? index;
  String? name;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        color: json["color"],
        icon: json["icon"],
        index: json["index"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "color": color,
        "icon": icon,
        "index": index,
        "name": name,
      };
}

class Subcategories {
  Subcategories({
    this.subCategoryDetail,
  });

  SubCategoryDetail? subCategoryDetail;

  factory Subcategories.fromJson(Map<String, dynamic> json) => Subcategories(
        subCategoryDetail:
            SubCategoryDetail.fromJson(json["subCategoryDetail"]),
      );

  Map<String, dynamic> toJson() => {
        "subCategoryDetail": subCategoryDetail?.toJson(),
      };
}

class SubCategoryDetail {
  SubCategoryDetail({
    this.content,
    this.coverImage,
    this.description,
    this.name,
    this.rating,
  });

  Content? content;
  String? coverImage;
  String? description;
  String? name;
  double? rating;

  factory SubCategoryDetail.fromJson(Map<String, dynamic> json) =>
      SubCategoryDetail(
        content: Content.fromJson(json["content"]),
        coverImage: json["cover_image"],
        description: json["description"],
        name: json["name"],
        rating: json["rating"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "content": content?.toJson(),
        "cover_image": coverImage,
        "description": description,
        "name": name,
        "rating": rating,
      };
}

class Content {
  Content({
    this.quiz,
    this.video,
  });

  int? quiz;
  int? video;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        quiz: json["quiz"],
        video: json["video"],
      );

  Map<String, dynamic> toJson() => {
        "quiz": quiz,
        "video": video,
      };
}
