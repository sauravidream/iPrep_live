import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/references.dart';
import 'package:idream/custom_widgets/linear_percent_indicator.dart';
import 'package:idream/custom_widgets/loader.dart';

import 'package:idream/ui/dashboard/extra_books/extra_book_widget.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class ExtraBookRenderingPage extends StatefulWidget {
  final ExtraBooksWidget? chapterBookTileWidget;
  final index;
  final bookName;
  final bookIndex;
  final String? bookUrl;

  const ExtraBookRenderingPage(
      {Key? key,
      this.index,
      this.bookName,
      this.chapterBookTileWidget,
      this.bookIndex,
      this.bookUrl})
      : super(key: key);

  @override
  _ExtraBookRenderingPageState createState() => _ExtraBookRenderingPageState();
}

class _ExtraBookRenderingPageState extends State<ExtraBookRenderingPage> {
  Uint8List? _uint8list;
  static const int _initialPage = 0;
  int _actualPageNumber = _initialPage, _allPagesCount = 0;
  int PageNumber = _initialPage + 1;
  bool isSampleDoc = true;
  late PdfControllerPinch _pdfController;
  bool _isLoading = true;

  Future<Uint8List?> downloadFile() async {
    HttpClient httpClient = HttpClient();

    String? myUrl;
    myUrl = widget.bookUrl ??
        widget.chapterBookTileWidget!.extraBookModel!
            .bookList![widget.bookIndex].topics![widget.index].onlineLink!;

    try {
      HttpClient client = HttpClient();
      HttpClientRequest request = await client.getUrl(Uri.parse(myUrl));
      // var request = await httpClient.getUrl(Uri.parse(myUrl));
      var response = await request.close();
      _uint8list = await consolidateHttpClientResponseBytes(response);
      debugPrint(_uint8list.toString());
    } catch (ex) {
      debugPrint(ex.toString());
    }

    return _uint8list;
  }

  @override
  void initState() {
    downloadFile().then((value) {
      _pdfController = PdfControllerPinch(
        document: PdfDocument.openData(value!),
        initialPage: 1,
      );
      setState(() => _isLoading = false);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: _allPagesCount == 0
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: LinearPercentIndicator(
                  percent: _actualPageNumber / _allPagesCount,
                  progressColor: const Color(0xFF3399FF),
                ),
              ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFFFFFF),
        leading: IconButton(
          icon: Image.asset(
            "assets/images/back_icon.png",
            height: 25,
            width: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          widget.bookName.toString(),
          style: const TextStyle(
            color: Color(0xFF212121),
            fontSize: 16,
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFFFFFFF),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: PdfViewPinch(
                  pageSnapping: false,
                  documentLoader: const CircularProgressIndicator(),
                  pageLoader: const CircularProgressIndicator(),
                  controller: _pdfController,
                  onDocumentLoaded: (document) {
                    setState(() {
                      _allPagesCount = document.pagesCount;
                      totalBookOrNotesPageCount = document.pagesCount;
                    });
                  },
                  onPageChanged: (page) {
                    setState(() {
                      _actualPageNumber = page;
                      totalReadBookOrNotesPageCount = page;
                    });
                  },
                ),
              ),
      ),
    );
  }
}

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   bool _isLoading = true;
//   PDFDocument? document;
//
//   @override
//   void initState() {
//     super.initState();
//     loadDocument();
//   }
//
//   loadDocument() async {
//     document = await PDFDocument.fromAsset('assets/sample.pdf');
//
//     setState(() => _isLoading = false);
//   }
//
//   changePDF(value) async {
//     setState(() => _isLoading = true);
//     if (value == 1) {
//       document = await PDFDocument.fromAsset('assets/sample2.pdf');
//     } else if (value == 2) {
//       document = await PDFDocument.fromURL(
//         "https://unec.edu.az/application/uploads/2014/12/pdf-sample.pdf",
//         /* cacheManager: CacheManager(
//           Config(
//             "customCacheKey",
//             stalePeriod: const Duration(days: 2),
//             maxNrOfCacheObjects: 10,
//           ),
//         ), */
//       );
//     } else {
//       document = await PDFDocument.fromAsset('assets/sample.pdf');
//     }
//     setState(() => _isLoading = false);
//     Navigator.pop(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: Drawer(
//         child: Column(
//           children: <Widget>[
//             const SizedBox(height: 36),
//             ListTile(
//               title: const Text('Load from Assets'),
//               onTap: () {
//                 changePDF(1);
//               },
//             ),
//             ListTile(
//               title: const Text('Load from URL'),
//               onTap: () {
//                 changePDF(2);
//               },
//             ),
//             ListTile(
//               title: const Text('Restore default'),
//               onTap: () {
//                 changePDF(3);
//               },
//             ),
//           ],
//         ),
//       ),
//       appBar: AppBar(
//         title: const Text('FlutterPluginPDFViewer'),
//       ),
//       body: Center(
//         child: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : PDFViewer(
//                 document: document!,
//                 zoomSteps: 1,
//                 //uncomment below line to preload all pages
//                 // lazyLoad: false,
//                 // uncomment below line to scroll vertically
//                 // scrollDirection: Axis.vertical,
//
//                 //uncomment below code to replace bottom navigation with your own
//                 /* navigationBuilder:
//                           (context, page, totalPages, jumpToPage, animateToPage) {
//                         return ButtonBar(
//                           alignment: MainAxisAlignment.spaceEvenly,
//                           children: <Widget>[
//                             IconButton(
//                               icon: Icon(Icons.first_page),
//                               onPressed: () {
//                                 jumpToPage()(page: 0);
//                               },
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.arrow_back),
//                               onPressed: () {
//                                 animateToPage(page: page - 2);
//                               },
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.arrow_forward),
//                               onPressed: () {
//                                 animateToPage(page: page);
//                               },
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.last_page),
//                               onPressed: () {
//                                 jumpToPage(page: totalPages - 1);
//                               },
//                             ),
//                           ],
//                         );
//                       }, */
//               ),
//       ),
//     );
//   }
// }
