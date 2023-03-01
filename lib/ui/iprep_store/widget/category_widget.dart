import 'package:flutter/material.dart';
import 'package:idream/ui/iprep_store/widget/sub_category_widget.dart';

import '../../../model/iprep_store_model/categories_dtl_model.dart';
import '../sub_categories_page.dart';
import 'category_header.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({Key? key, this.categoryDtlModel, this.categoryId})
      : super(key: key);
  final String? categoryId;
  final CategoryDtlModel? categoryDtlModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35),
      child: SizedBox(
        // color: Colors.red,
        height: 260,
        child: Column(
          children: [
            CategoryHeader(
                onTap: categoryDtlModel?.subcategories?.length == 1
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubCategoriesPage(
                              categoryName:
                                  categoryDtlModel?.details?.name ?? "",
                              categoryId: categoryId,
                            ),
                          ),
                        );
                      },
                headerName: categoryDtlModel?.subcategories?.length == 1
                    ? categoryDtlModel?.subcategories![0].name
                    : categoryDtlModel?.details?.name ?? ""),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 15),
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: categoryDtlModel?.subcategories?.length,
                itemBuilder: (context, int index) {
                  return categoryDtlModel?.subcategories?.length != 1
                      ? Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: SubCategoryWidget(
                            categoryId: categoryId,
                            subcategory:
                                categoryDtlModel?.subcategories?[index],
                          ),
                        )
                      : SingleSubCategoryWidget(
                          subcategory: categoryDtlModel?.subcategories?[index],
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryWidgetLis extends StatelessWidget {
  const CategoryWidgetLis({Key? key, this.categoryDtlModel}) : super(key: key);
  final CategoryModel? categoryDtlModel;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categoryDtlModel?.id?.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return CategoryWidget(
            categoryId: categoryDtlModel?.id?[index],
            categoryDtlModel: categoryDtlModel?.categoryDtlModel![index],
          );
        });
  }
}
