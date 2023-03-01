import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idream/ui/iprep_store/sub_categories_page.dart';
import '../../common/color_extensio.dart';
import '../../model/iprep_store_model/categories_model.dart';

class CategoryListingPage extends StatelessWidget {
  const CategoryListingPage({Key? key, this.category}) : super(key: key);
  final List<CategoryData>? category;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context),
      body: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemBuilder: (context, index) {
            return CategoryListTile(
              category: category?[index],
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 29);
          },
          itemCount: category?.length ?? 0),
    );
  }
}

class CategoryListTile extends StatelessWidget {
  const CategoryListTile({Key? key, this.category}) : super(key: key);
  final CategoryData? category;
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: leading(),
        title: title(),
        trailing: subtitle(),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubCategoriesPage(
                      categoryId: category?.id,
                      categoryName: category?.name,
                    ))));
  }

  Widget? leading() {
    return Material(
      borderRadius: BorderRadius.circular(4),
      elevation: .1,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          //F9FAFB

          color: category?.color?.toColor(),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            width: 41,
            height: 40,
            imageUrl: category?.icon ??
                "https://firebasestorage.googleapis.com/v0/b/iprep-7f10a.appspot.com/o/L0%20Icons%2FVector.png?alt=media&token=b76d07ad-116b-4544-ae11-25ed002a26de",
            fit: BoxFit.fill,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
              child: SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                  strokeWidth: 0.5,
                ),
              ),
            ),
            errorWidget: (context, url, error) =>
                const Center(child: Icon(Icons.error)),
          ),
        ),
      ),
    );
  }

  Widget? title() {
    return Text(
      category?.name ?? "",
      style: const TextStyle(
        fontFamily: "Inter",
        color: Color(0xFF212121),
        fontWeight: FontWeight.normal,
        fontSize: 15,
      ),
    );
  }

  Widget? subtitle() {
    return SvgPicture.asset(
      "assets/image/forword_icon.svg",
      height: 24,
      width: 24,
    );
  }
}

PreferredSizeWidget appBarWidget(context) {
  return AppBar(
    elevation: 0,
    backgroundColor: const Color(0xFFFFFFFF),
    centerTitle: false,
    leading: IconButton(
      icon: SvgPicture.asset(
        "assets/image/backward_arrow.svg",
        height: 19,
        width: 19,
      ),
      onPressed: () => Navigator.pop(context),
    ),
    title: const Text(
      "All Categories",
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF212121),
        fontStyle: FontStyle.normal,
      ),
    ),
  );
}
