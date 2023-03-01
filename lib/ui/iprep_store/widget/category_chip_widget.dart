import 'package:flutter/material.dart';
import '../../../model/iprep_store_model/categories_model.dart';
import '../categor_listing_page.dart';
import '../sub_categories_page.dart';
import 'category_header.dart';

class CategoriesChip extends StatelessWidget {
  const CategoriesChip(
    this.categoryData, {
    Key? key,
  }) : super(key: key);
  final CategoryData? categoryData;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 0),
      child: ActionChip(
          pressElevation: 0,
          elevation: 0,
          backgroundColor: const Color(0xFFD9D9D9).withOpacity(.2),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          label: Text(
            categoryData?.name ?? "",
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF020202)),
          ),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SubCategoriesPage(
                        categoryId: categoryData?.id,
                        categoryName: categoryData?.name,
                      )))),
    );
  }
}

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({Key? key, required this.category}) : super(key: key);
  final List<CategoryData>? category;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        CategoryHeader(
            headerName: "Categories",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CategoryListingPage(
                            category: category,
                          )));
            }),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 15),
          child: Wrap(
            alignment: WrapAlignment.start,
            children: List.generate(
              category!.length,
              (index) => CategoriesChip(
                category?[index],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
