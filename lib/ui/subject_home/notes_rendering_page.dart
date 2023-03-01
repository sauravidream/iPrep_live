import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:idream/common/references.dart';
import 'package:idream/custom_widgets/linear_percent_indicator.dart';
import 'package:idream/custom_widgets/loader.dart';
import 'package:idream/model/notes_model.dart';
import 'package:idream/ui/subject_home/notes_page.dart';
import 'package:internet_file/internet_file.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class NotesRenderingPage extends StatefulWidget {
  final NotesModel? notesModel;
  final NotesPage? notesPageWidget;

  const NotesRenderingPage({
    Key? key,
    this.notesModel,
    this.notesPageWidget,
  }) : super(key: key);

  @override
  _NotesRenderingPageState createState() => _NotesRenderingPageState();
}

class _NotesRenderingPageState extends State<NotesRenderingPage> {
  static const int _initialPage = 0;
  int _actualPageNumber = _initialPage, _allPagesCount = 0;

  bool isSampleDoc = true;
  late PdfControllerPinch _pdfController;
  bool _isLoading = true;

  @override
  void initState() {
    InternetFile.get(widget.notesModel!.noteOnlineLink!).then((value) {
      debugPrint(value.toString());
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
        //TODO: Uncommenting it as we have no use of it for now.
        // actions: [
        //   IconButton(
        //     icon: Image.asset(
        //       "assets/images/3_dot.png",
        //       height: ScreenUtil().setSp(25, ),
        //       width: ScreenUtil().setSp(25, ),
        //       color: Color(0xFF212121),
        //     ),
        //     onPressed: () {},
        //   ),
        // ],
        title: Text(
          "${widget.notesModel!.noteName}",
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

/*

class NotesRenderingPage extends StatefulWidget {
  final NotesModel? notesModel;
  final NotesPage? notesPageWidget;

  const NotesRenderingPage({
    Key? key,
    this.notesModel,
    this.notesPageWidget,
  }) : super(key: key);

  @override
  _NotesRenderingPageState createState() => _NotesRenderingPageState();
}

class _NotesRenderingPageState extends State<NotesRenderingPage> {
  late EpubController _epubReaderController;
  Uint8List? _uint8list;
  static const int _initialPage = 0;
  int _actualPageNumber = _initialPage, _allPagesCount = 0;

  bool isSampleDoc = true;
  late PdfControllerPinch _pdfController;
  bool _isLoading = true;
  Future<Uint8List?> downloadFile() async {
    HttpClient httpClient = HttpClient();

    String? myUrl;
    myUrl = widget.notesModel!.noteOnlineLink!;

    try {
      HttpClient client = HttpClient();
      HttpClientRequest request = await client.getUrl(Uri.parse(myUrl));
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
    InternetFile.get(widget.notesModel!.noteOnlineLink!).then((value) {
      _epubReaderController =
          EpubController(document: EpubDocument.openData(value));
    });

    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();

    super.dispose();
  }

  @override
  */
/* Widget build(BuildContext context) {
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
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.black,
          ),
          // icon: Image.asset(
          //   "assets/images/back_icon.png",
          //   height: 25,
          //   width: 25,
          // ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          "${widget.notesModel!.noteName}",
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
  }*/ /*


  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: EpubViewActualChapter(
        controller: _epubReaderController,
        builder: (chapterValue) => Text(
          chapterValue?.chapter?.Title?.replaceAll('\n', '').trim() ?? '',
          textAlign: TextAlign.start,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.save_alt),
          color: Colors.white,
          onPressed: () => _showCurrentEpubCfi(context),
        ),
      ],
    ),
    drawer: Drawer(
      child: EpubViewTableOfContents(controller: _epubReaderController),
    ),
    body: EpubView(
      builders: EpubViewBuilders<DefaultBuilderOptions>(
        options: const DefaultBuilderOptions(),
        chapterDividerBuilder: (_) => const Divider(),
      ),
      controller: _epubReaderController,
    ),
  );

  void _showCurrentEpubCfi(context) {
    final cfi = _epubReaderController.generateEpubCfi();

    if (cfi != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(cfi),
          action: SnackBarAction(
            label: 'GO',
            onPressed: () {
              _epubReaderController.gotoEpubCfi(cfi);
            },
          ),
        ),
      );
    }
  }
}
*/
