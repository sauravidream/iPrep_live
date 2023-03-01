import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../model/iprep_store_model/categories_dtl_model.dart';
import '../sub_categories_dtl_page.dart';

class SubCategoryWidget extends StatelessWidget {
  const SubCategoryWidget(
      {Key? key, required this.subcategory, required this.categoryId})
      : super(key: key);
  final Subcategory? subcategory;
  final String? categoryId;
  @override
  Widget build(BuildContext context) {
    return InkResponse(
      radius: 100,
      borderRadius: BorderRadius.circular(100),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SubCategoriesDTLPage(subcategory: subcategory))),
      child: SizedBox(
        height: 260,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: CachedNetworkImage(
                width: 191,
                height: 120,
                imageUrl: subcategory?.coverImage ??
                    "https://firebasestorage.googleapis.com/v0/b/flutter-firebase-ddd-ac130.appspot.com/o/badminton.png?alt=media&token=ae0b7ff9-fd0d-4c32-bf87-0f644cbbde06",
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(subcategory?.name ?? "",
                maxLines: 1,
                style: const TextStyle(
                  overflow: TextOverflow.clip,
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                  fontStyle: FontStyle.normal,
                )),
            const SizedBox(height: 4),
            SizedBox(
              width: 171,
              // height: 100,
              child: Text(
                subcategory?.description ?? "",
                maxLines: 2,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  height: 1.4,
                  overflow: TextOverflow.clip,
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF5C5C5C),
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 171,
              child: Text(
                "${subcategory?.content?.video ?? ''} Videos",
                maxLines: 1,
                style: const TextStyle(
                  overflow: TextOverflow.clip,
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF8A8A8E),
                  fontStyle: FontStyle.normal,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SingleSubCategoryWidget extends StatelessWidget {
  const SingleSubCategoryWidget({Key? key, required this.subcategory})
      : super(key: key);
  final Subcategory? subcategory;
  @override
  Widget build(BuildContext context) {
    return InkResponse(
      radius: 100,
      borderRadius: BorderRadius.circular(100),
      // onTap: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => const SubCategoriesDTLPage())),
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: CachedNetworkImage(
                width: MediaQuery.of(context).size.width * .90,
                // height: 200,
                imageUrl: subcategory?.coverImage ??
                    "https://firebasestorage.googleapis.com/v0/b/flutter-firebase-ddd-ac130.appspot.com/o/badminton.png?alt=media&token=ae0b7ff9-fd0d-4c32-bf87-0f644cbbde06",
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            // const SizedBox(height: 10),
            // Text(subcategory?.name ?? "",
            //     maxLines: 1,
            //     style: const TextStyle(
            //       overflow: TextOverflow.clip,
            //       fontFamily: 'Inter',
            //       fontSize: 16,
            //       fontWeight: FontWeight.w600,
            //       color: Color(0xFF212121),
            //       fontStyle: FontStyle.normal,
            //     )),
            const SizedBox(height: 4),
            SizedBox(
              width: 171,
              // height: 100,
              child: Text(
                subcategory?.description ?? "",
                maxLines: 2,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  overflow: TextOverflow.clip,
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5C5C5C),
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 171,
              child: Text(
                "${subcategory?.content?.video ?? ''} Videos",
                maxLines: 1,
                style: const TextStyle(
                  overflow: TextOverflow.clip,
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5C5C5C),
                  fontStyle: FontStyle.normal,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
