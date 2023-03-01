import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/references.dart';
import 'package:idream/custom_widgets/chapter_book_tile.dart';
import 'package:idream/custom_widgets/linear_percent_indicator.dart';
import 'package:idream/custom_widgets/loader.dart';
import 'package:internet_file/internet_file.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class BookRenderingPage extends StatefulWidget {
  final ChapterBookTile? chapterBookTileWidget;

  const BookRenderingPage({
    Key? key,
    this.chapterBookTileWidget,
  }) : super(key: key);

  @override
  _BookRenderingPageState createState() => _BookRenderingPageState();
}

class _BookRenderingPageState extends State<BookRenderingPage> {
  static const int _initialPage = 0;
  int _actualPageNumber = _initialPage, _allPagesCount = 0;

  bool isSampleDoc = true;
  late PdfControllerPinch _pdfController;
  bool _isLoading = true;

  @override
  void initState() {
    InternetFile.get(widget.chapterBookTileWidget!.booksModel!.bookOnlineLink!)
        .then((value) {
      _pdfController = PdfControllerPinch(
        document: PdfDocument.openData(value),
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
          widget.chapterBookTileWidget!.booksModel!.bookName!,
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
                    setState(
                      () {
                        _actualPageNumber = page;
                        totalReadBookOrNotesPageCount = page;
                      },
                    );
                  },
                ),
              ),
      ),
    );
  }
}
