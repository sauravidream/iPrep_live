// To parse this JSON data, do
//
//     final categoryDtlModel = categoryDtlModelFromJson(jsonString);

import 'package:idream/model/iprep_store_model/categories_model.dart';

class CategoryModel {
  CategoryModel({
    this.id,
    this.categoryDtlModel,
  });

  List<dynamic>? id;
  List<CategoryDtlModel>? categoryDtlModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
      id: List<dynamic>.from(json.keys),
      categoryDtlModel: List<CategoryDtlModel>.from(
          json.values.map((e) => CategoryDtlModel.fromJson(e))));
}

class CategoryDtlModel {
  CategoryDtlModel({
    this.details,
    this.subcategories,
  });

  CategoryData? details;
  List<Subcategory>? subcategories;

  factory CategoryDtlModel.fromJson(Map<String, dynamic> json) {
    return CategoryDtlModel(
        details: CategoryData.fromJson(json["details"]),
        subcategories: List<Subcategory>.from(
            json["sub_categories"].values.map((e) => Subcategory.fromJson(e))));
  }

  Map<String, dynamic> toJson() => {
        "details": details?.toJson(),
        "subcategories":
            List<dynamic>.from(subcategories!.map((x) => x.toJson())),
      };
}

class Subcategory {
  Subcategory({
    this.content,
    this.coverImage,
    this.description,
    this.name,
    this.rating,
    this.subcategoryId,
  });

  Content? content;
  String? coverImage;
  String? description;
  String? name;
  String? subcategoryId;
  double? rating;

  factory Subcategory.fromJson(Map<dynamic, dynamic> json) {
    return Subcategory(
      content: Content.fromJson(json["content"]),
      coverImage: json["cover_image"],
      description: json["description"],
      name: json["name"],
      rating: json["rating"].toDouble(),
      subcategoryId: json["id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "content": content?.toJson(),
        "cover_image": coverImage,
        "description": description,
        "name": name,
        "rating": rating,
        "id": subcategoryId
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
        video: json["videos"],
      );

  Map<String, dynamic> toJson() => {
        "quiz": quiz,
        "videos": video,
      };
}
