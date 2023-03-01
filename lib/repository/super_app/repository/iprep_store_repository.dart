import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../model/iprep_store_model/categories_dtl_model.dart';
import '../../../model/iprep_store_model/categories_model.dart';
import '../../../model/iprep_store_model/video_model.dart';

class StoreRepository {
  final baseUrl = "https://iprep-super-app.herokuapp.com/api/";

  Future create() {
    throw UnimplementedError();
  }

  Future delete() {
    // TODO: implement delete
    throw UnimplementedError();
  }

  Future update() {
    // TODO: implement update
    throw UnimplementedError();
  }

  Future watchUncompleted() {
    // TODO: implement watchUncompleted
    throw UnimplementedError();
  }

  Future<List<CategoryData>> read() async {
    List<CategoryData> category = [];
    try {
      final response = await Dio().get("${baseUrl}categories/limited");

      (response.data as Map).forEach((key, value) {
        category.add(CategoryData.fromJson(value));
      });

      return category;
    } catch (e) {
      debugPrint(e.toString());
      return null!;
    }
  }

  Future getAllCategory() async {
    CategoryModel? category;
    try {
      final response = await Dio().get("${baseUrl}subcategories/all");

      category = CategoryModel.fromJson(response.data);

      return category;
    } catch (e) {
      debugPrint(e.toString());
    }
    return category;
  }

  Future getSubCategory(String categoryId) async {
    List<Subcategory>? subCategory = [];
    try {
      final response = await Dio().get("${baseUrl}subcategories/$categoryId");

      (response.data as Map).forEach((key, value) {
        subCategory.add(Subcategory.fromJson(value));
      });

      return subCategory;
    } catch (e) {
      debugPrint(e.toString());
    }
    return subCategory;
  }

  Future getCategoryVideos(String? categoryId) async {
    VideoModel? videoData;
    List<Video> videoList = [];
    try {
      final response = await Dio().get("${baseUrl}lesson/$categoryId");

      videoData = VideoModel.fromJson(response.data);
      videoData.videos?.forEach((key, value) {
        videoList.add(value);
      });

      return videoList;
    } catch (e) {
      debugPrint(e.toString());
    }
    return videoList;
  }
}
