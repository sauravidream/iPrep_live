import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/model/test_prep_model/test_prep_model.dart';
import 'package:idream/model/user_plan_status_model/user_plan_status_model.dart';
import 'package:idream/repository/payment_repository.dart';
import 'package:idream/ui/dashboard/test_prep_web_page.dart';
import 'package:idream/ui/test_prep/test_prep_provider/test_proivider.dart';
import 'package:injectable/injectable.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'custom_pop_up.dart';

// class TestWidget extends StatelessWidget {
//   final String? testName;
//   final String? testId;
//   final String? testImagePath;
//   final String numberOfTests;
//   final String? testWebLink;
//   final String? packageName;
//   final ActivationResponseModel? statusResponse;
//
//   const TestWidget({
//     Key? key,
//     this.testName = "IIT-JEE Main",
//     required this.testId,
//     this.testImagePath = "assets/images/test_iit.png",
//     this.numberOfTests = "12 Tests",
//     required this.testWebLink,
//     this.packageName,
//     this.statusResponse,
//   }) : super(key: key);
//
//   final bool? isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final testPro = Provider.of<TestProvider>(context);
//     return Container(
//       margin: const EdgeInsets.only(right: 10, bottom: 10),
//       decoration: BoxDecoration(
//         border: Border.all(
//           width: 1.0,
//           color: const Color(0xFFFFd1d1d1),
//         ),
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child:
//       InkWell(
//         onTap: () async {
//           await testPro.onTapTestContainer(
//             packageName: packageName,
//             context: context,
//             testWebLink: testWebLink,
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//           child: Row(
//             children: [
//               CachedNetworkImage(
//                 imageUrl: testImagePath!,
//                 height: 36,
//                 width: 36,
//                 progressIndicatorBuilder: (context, url, downloadProgress) =>
//                     Center(
//                       child: SizedBox(
//                         height: 25,
//                         width: 25,
//                         child: CircularProgressIndicator(
//                           value: downloadProgress.progress,
//                           strokeWidth: 0.5,
//                         ),
//                       ),
//                     ),
//                 errorWidget: (context, url, error) => const Icon(
//                   Icons.school,
//                   size: 40,
//                 ),
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Flexible(
//                       child: Text(
//                         testName!,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           color: const Color(0xFF212121),
//                           fontSize: 14,
//                           fontWeight: FontWeight.values[5],
//                         ),
//                       ),
//                     ),
//                     Text(
//                       numberOfTests,
//                       style: const TextStyle(
//                         color: Color(0xFF9E9E9E),
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//
// class TestWidget extends StatelessWidget {
//   final String? testName;
//   final String? testId;
//   final String? testImagePath;
//   final String numberOfTests;
//   final String? testWebLink;
//   final String? packageName;
//   final ActivationResponseModel? statusResponse;
//
//   const TestWidget({
//     Key? key,
//     this.testName = "IIT-JEE Main",
//     required this.testId,
//     this.testImagePath = "assets/images/test_iit.png",
//     this.numberOfTests = "12 Tests",
//     required this.testWebLink,
//     this.packageName,
//     this.statusResponse,
//   }) : super(key: key);
//
//   final bool? isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final testPro = Provider.of<TestProvider>(context);
//     return Container(
//       margin: const EdgeInsets.only(right: 10, bottom: 10),
//       decoration: BoxDecoration(
//         border: Border.all(
//           width: 1.0,
//           color: const Color(0xFFFFd1d1d1),
//         ),
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child:
//       InkWell(
//         onTap: () async {
//           await testPro.onTapTestContainer(
//             packageName: packageName,
//             context: context,
//             testWebLink: testWebLink,
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//           child: Row(
//             children: [
//               CachedNetworkImage(
//                 imageUrl: testImagePath!,
//                 height: 36,
//                 width: 36,
//                 progressIndicatorBuilder: (context, url, downloadProgress) =>
//                     Center(
//                       child: SizedBox(
//                         height: 25,
//                         width: 25,
//                         child: CircularProgressIndicator(
//                           value: downloadProgress.progress,
//                           strokeWidth: 0.5,
//                         ),
//                       ),
//                     ),
//                 errorWidget: (context, url, error) => const Icon(
//                   Icons.school,
//                   size: 40,
//                 ),
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Flexible(
//                       child: Text(
//                         testName!,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           color: const Color(0xFF212121),
//                           fontSize: 14,
//                           fontWeight: FontWeight.values[5],
//                         ),
//                       ),
//                     ),
//                     Text(
//                       numberOfTests,
//                       style: const TextStyle(
//                         color: Color(0xFF9E9E9E),
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class TestWidget extends StatelessWidget {
  final SubCategory exams;
  final int subTitle;
  final Others? testPrepData;
  const TestWidget(
      {Key? key,
      required this.exams,
      required this.subTitle,
      this.testPrepData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final testPro = Provider.of<TestProvider>(context);
    return Stack(
      children: [
        InkWell(
          onTap: () {
            testPro.onTapTestContainer(
              context: context,
              packageName: testPrepData!.name,
              testWebLink: exams.href,
            );
          },
          borderRadius: BorderRadius.circular(7.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            // margin: const EdgeInsets.only(right: 10, bottom: 10),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.0,
                color: const Color(0xFFD1D1D1),
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildIcon(),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exams.name!,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: const TextStyle().copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          // color: book.color.getOrCrash(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Text(
                      //   "${subTitle.toString()} Exams",
                      //   textAlign: TextAlign.center,
                      //   style: const TextStyle().copyWith(
                      //     fontSize: 16.4,
                      //     fontWeight: FontWeight.w400,
                      //     // color: book.color.getOrCrash(),
                      //     overflow: TextOverflow.ellipsis,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildIcon() {
    return ImageWidget(
      imageUrl: exams.icon!,
    );
  }
}

class ImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? height;
  const ImageWidget({Key? key, required this.imageUrl, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height ?? 40,
      imageUrl: imageUrl,
      placeholder: (BuildContext context, String url) =>
          const Center(child: CircularProgressIndicator(strokeWidth: 1)),
      errorWidget: (BuildContext context, String url, dynamic error) =>
          const Center(
        child: Icon(
          Icons.school,
          size: 40,
        ),
      ),
    );
  }
}
