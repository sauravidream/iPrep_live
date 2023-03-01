import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idream/ui/iprep_store/widget/sub_category_widget.dart';

import '../../common/references.dart';
import '../../custom_widgets/loading_widget.dart';
import '../../model/iprep_store_model/categories_dtl_model.dart';

class SubCategoriesPage extends StatelessWidget {
  const SubCategoriesPage({
    Key? key,
    this.categoryName,
    this.categoryId,
  }) : super(key: key);

  final String? categoryName;
  final String? categoryId;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: appBarWidget(context, categoryName ?? ''),
      body: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: FutureBuilder(
            future: storeRepository.getSubCategory(categoryId ?? "all"),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              Widget categoryWidget;

              if (snapshot.data != null) {
                List<Subcategory>? subCategory = snapshot.data;
                /* categoryWidget = ListView(
                  padding: const EdgeInsets.only(left: 15, top: 30),
                  scrollDirection: Axis.vertical,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.start,
                      children: List.generate(
                        growable: true,
                        subCategory!.length,
                        (index) => SubCategoryWidget(
                          categoryId: categoryId,
                          subcategory: snapshot.data?[index],
                        ),
                      ),
                    ),
                  ],
                );*/
                categoryWidget = Center(
                  child: GridView.count(
                    primary: false,
                    addAutomaticKeepAlives: true,
                    padding: const EdgeInsets.only(left: 15, top: 10),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 15,
                    crossAxisCount: size.width > 500 ? 3 : 2,
                    children: List.generate(
                      growable: true,
                      subCategory!.length,
                      (index) => SubCategoryWidget(
                        categoryId: categoryId,
                        subcategory: snapshot.data?[index],
                      ),
                    ),
                  ),
                );
              } else {
                categoryWidget = const LoadingWidget(
                  height: 100,
                );
              }

              return categoryWidget;
            }),
      ),
    );
  }

  PreferredSizeWidget appBarWidget(context, String categoryName) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(91.0),
      child: AppBar(
        scrolledUnderElevation: 1,
        elevation: 0,
        backgroundColor: const Color(0xFFFFFFFF),
        // backgroundColor: Colors.amber,
        centerTitle: false,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/image/backward_arrow.svg",
            height: 19,
            width: 19,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          categoryName,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
    );
  }
}
