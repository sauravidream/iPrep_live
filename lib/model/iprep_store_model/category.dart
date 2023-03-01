import 'package:idream/model/iprep_store_model/categories_dtl_model.dart';

class CategoryDetailsModel {
  CategoryDetailsModel({this.categoryList});
  List<Category>? categoryList;

  factory CategoryDetailsModel.fromJson(Map<String, dynamic> json) =>
      CategoryDetailsModel(
        categoryList:
            List<Category>.from(json.values.map((e) => Category.fromJson(e))),
      );

  /*List<Category>.from(
              json.keys.map((x) => Category.fromJson(json))))*/

}

class Category {
  Category({this.categoryId, this.categoryDetail});
  List<CategoryId>? categoryId;
  List<CategoryDetail>? categoryDetail;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
      categoryDetail: List<CategoryDetail>.from(
          json.values.map((e) => CategoryDetail.fromJson(e))),
      categoryId: List<CategoryId>.from(json.keys));
}

class CategoryId {
  CategoryId({this.categoryId});
  String? categoryId;
}

class CategoryDetail {
  CategoryDetail({
    this.content,
    this.coverImage,
    this.description,
    this.id,
    this.name,
    this.rating,
  });

  Content? content;
  String? coverImage;
  String? description;
  String? id;
  String? name;
  double? rating;

  factory CategoryDetail.fromJson(Map<String, dynamic> json) => CategoryDetail(
        content: Content.fromJson(json["content"]),
        coverImage: json["cover_image"],
        description: json["description"],
        id: json["id"],
        name: json["name"],
        rating: json["rating"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "content": content?.toJson(),
        "cover_image": coverImage,
        "description": description,
        "id": id,
        "name": name,
        "rating": rating,
      };
}

class Content {
  Content({
    this.videos,
  });

  int? videos;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        videos: json["videos"],
      );

  Map<String, dynamic> toJson() => {
        "videos": videos,
      };
}
