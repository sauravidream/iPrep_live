// import 'package:flutter/material.dart';
//
// import 'package:google_fonts/google_fonts.dart';
// import 'package:idream/common/constants.dart';
// import 'package:idream/custom_widgets/linear_percent_indicator.dart';
// import 'package:idream/model/my_reports_model.dart';
//
// class MyReportsDetailPage extends StatefulWidget {
//   final MyReportsModel myReportsModel;
//   MyReportsDetailPage({this.myReportsModel});
//
//   @override
//   _MyReportsDetailPageState createState() => _MyReportsDetailPageState();
// }
//
// class _MyReportsDetailPageState extends State<MyReportsDetailPage> {
//   bool _listPrepared = false;
//   List<MyReportDetailedModel> _listMyReportsDetailPage = [];
//
//   Future _preparePageDataList() async {
//     //Books
//     if (widget.myReportsModel.myReportBooksModelList != null)
//       widget.myReportsModel.myReportBooksModelList
//           .forEach((myReportBooksModel) {
//         MyReportDetailedModel _myReportsDetailModel = MyReportDetailedModel();
//         _myReportsDetailModel.topicName = myReportBooksModel.bookName;
//         _myReportsDetailModel.booksReadCount =
//             (int.parse(_myReportsDetailModel.booksReadCount) + 1).toString();
//         _listMyReportsDetailPage.add(_myReportsDetailModel);
//       });
//     //Notes
//     if (widget.myReportsModel.myReportNotesModelList != null)
//       widget.myReportsModel.myReportNotesModelList
//           .forEach((myReportNotesModel) {
//         int _alreadyPresentRowIndex = _listMyReportsDetailPage.indexWhere(
//             (element) => (element.topicName == myReportNotesModel.topicName));
//         if (_alreadyPresentRowIndex == -1) {
//           MyReportDetailedModel _myReportsDetailModel = MyReportDetailedModel();
//           _myReportsDetailModel.topicName = myReportNotesModel.topicName;
//           _myReportsDetailModel.notesReadCount =
//               (int.parse(_myReportsDetailModel.notesReadCount) + 1).toString();
//           _listMyReportsDetailPage.add(_myReportsDetailModel);
//         } else {
//           _listMyReportsDetailPage[_alreadyPresentRowIndex].topicName =
//               myReportNotesModel.topicName;
//           _listMyReportsDetailPage[_alreadyPresentRowIndex].notesReadCount =
//               (int.parse(_listMyReportsDetailPage[_alreadyPresentRowIndex]
//                           .notesReadCount) +
//                       1)
//                   .toString();
//         }
//       });
//     //Tests
//     if (widget.myReportsModel.myReportTestModelList != null)
//       widget.myReportsModel.myReportTestModelList.forEach((myReportTestModel) {
//         int _alreadyPresentRowIndex = _listMyReportsDetailPage.indexWhere(
//             (element) => (element.topicName == myReportTestModel.topicName));
//         if (_alreadyPresentRowIndex == -1) {
//           MyReportDetailedModel _myReportsDetailModel = MyReportDetailedModel();
//           _myReportsDetailModel.topicName = myReportTestModel.topicName;
//           _myReportsDetailModel.testsAttempted =
//               (int.parse(_myReportsDetailModel.testsAttempted) + 1).toString();
//           _listMyReportsDetailPage.add(_myReportsDetailModel);
//         } else {
//           _listMyReportsDetailPage[_alreadyPresentRowIndex].topicName =
//               myReportTestModel.topicName;
//           _listMyReportsDetailPage[_alreadyPresentRowIndex].testsAttempted =
//               (int.parse(_listMyReportsDetailPage[_alreadyPresentRowIndex]
//                           .testsAttempted) +
//                       1)
//                   .toString();
//         }
//       });
//     //Practice
//     if (widget.myReportsModel.myReportPracticeModelList != null)
//       widget.myReportsModel.myReportPracticeModelList
//           .forEach((myReportPracticeModel) {
//         int _alreadyPresentRowIndex = _listMyReportsDetailPage.indexWhere(
//             (element) =>
//                 (element.topicName == myReportPracticeModel.topicName));
//         if (_alreadyPresentRowIndex == -1) {
//           MyReportDetailedModel _myReportsDetailModel = MyReportDetailedModel();
//           _myReportsDetailModel.topicName = myReportPracticeModel.topicName;
//           _myReportsDetailModel.practiceAttempted =
//               (int.parse(_myReportsDetailModel.practiceAttempted) + 1)
//                   .toString();
//           _listMyReportsDetailPage.add(_myReportsDetailModel);
//         } else {
//           _listMyReportsDetailPage[_alreadyPresentRowIndex].topicName =
//               myReportPracticeModel.topicName;
//           _listMyReportsDetailPage[_alreadyPresentRowIndex].practiceAttempted =
//               (int.parse(_listMyReportsDetailPage[_alreadyPresentRowIndex]
//                           .practiceAttempted) +
//                       1)
//                   .toString();
//         }
//       });
//     //Video Lessons
//     if (widget.myReportsModel.myReportVideoLessonsModelList != null)
//       widget.myReportsModel.myReportVideoLessonsModelList
//           .forEach((myReportVideoLessonsModel) {
//         int _alreadyPresentRowIndex = _listMyReportsDetailPage.indexWhere(
//             (element) =>
//                 (element.topicName == myReportVideoLessonsModel.topicName));
//         if (_alreadyPresentRowIndex == -1) {
//           MyReportDetailedModel _myReportsDetailModel = MyReportDetailedModel();
//           _myReportsDetailModel.topicName = myReportVideoLessonsModel.topicName;
//           _myReportsDetailModel.videosWatched =
//               (int.parse(_myReportsDetailModel.videosWatched) + 1).toString();
//           _listMyReportsDetailPage.add(_myReportsDetailModel);
//         } else {
//           _listMyReportsDetailPage[_alreadyPresentRowIndex].topicName =
//               myReportVideoLessonsModel.topicName;
//           _listMyReportsDetailPage[_alreadyPresentRowIndex].videosWatched =
//               (int.parse(_listMyReportsDetailPage[_alreadyPresentRowIndex]
//                           .videosWatched) +
//                       1)
//                   .toString();
//         }
//       });
//     return;
//   }
//
//   AppBar returnAppBar() {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: Colors.white,
//       centerTitle: false,
//       leadingWidth: ScreenUtil().setSp(0, ),
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Image.asset(
//                   "assets/images/back_icon.png",
//                   height: ScreenUtil().setSp(25, ),
//                   width: ScreenUtil().setSp(25, ),
//                 ),
//               ),
//               SizedBox(
//                 width: ScreenUtil().setSp(12, ),
//               ),
//               Text(
//                 widget.myReportsModel.subjectID.replaceRange(
//                     0,
//                     1,
//                     widget.myReportsModel.subjectID
//                         .substring(0, 1)
//                         .toUpperCase()),
//                 style: TextStyle(
//                   fontSize: ScreenUtil().setSp(20, ),
//                   fontWeight: FontWeight.values[5],
//                   color: Color((Constants.subjectColorAndImageMap[
//                               widget.myReportsModel.subjectID] !=
//                           null)
//                       ? Constants.subjectColorAndImageMap[
//                           widget.myReportsModel.subjectID]['subjectColor']
//                       : 0xFFFCAC52),
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: EdgeInsets.only(
//               right: ScreenUtil().setSp(19, ),
//             ),
//             child: Hero(
//               tag: "SubjectTag${widget.myReportsModel.subjectID}",
//               child: Image.asset(
//                 (Constants.subjectColorAndImageMap[
//                             widget.myReportsModel.subjectID] !=
//                         null)
//                     ? Constants.subjectColorAndImageMap[
//                         widget.myReportsModel.subjectID]['assetPath']
//                     : "assets/images/physics.png",
//                 height: ScreenUtil().setSp(43, ),
//                 width: ScreenUtil().setSp(43, ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future findMostWatchedChapterName() async {}
//
//   @override
//   void initState() {
//     super.initState();
//     _preparePageDataList().then((value) {
//       setState(() {
//         _listPrepared = true;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           appBar: returnAppBar(),
//           body: _listPrepared
//               ? SingleChildScrollView(
//                   child: Container(
//                     color: Colors.white,
//                     padding: EdgeInsets.symmetric(
//                       vertical:
//                           ScreenUtil().setSp(8, ),
//                     ),
//                     child: Column(
//                       children: [
//                         //place overall mastery row here
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: ScreenUtil()
//                                 .setSp(16, ),
//                           ),
//                           child: Row(
//                             children: [
//                               reportHeaderTopWatchedRow(
//                                 chapterName: widget
//                                     .myReportsModel.mostWatchedChapterName,
//                                 count: widget
//                                     .myReportsModel.mostWatchedChapterNameCount,
//                               ),
//                               reportHeaderOverAllMasteryRow(
//                                   percentage: (widget
//                                           .myReportsModel.subjectLevelMastery)
//                                       .toStringAsFixed(1)),
//                             ],
//                           ),
//                         ),
//                         //(4321.12345678).toStringAsFixed(3)
//                         SizedBox(
//                           height: ScreenUtil()
//                               .setSp(11.5, ),
//                         ),
//                         Image.asset(
//                           "assets/images/line_1.png",
//                         ),
//                         ListView.builder(
//                           itemCount: _listMyReportsDetailPage.length,
//                           shrinkWrap: true,
//                           padding: EdgeInsets.symmetric(
//                             horizontal: ScreenUtil()
//                                 .setSp(16, ),
//                           ),
//                           physics: NeverScrollableScrollPhysics(),
//                           itemBuilder: (context, index) {
//                             return ExpandableTile(
//                               title:
//                                   _listMyReportsDetailPage[index].topicName ??
//                                       "",
//                               booksReadCount: _listMyReportsDetailPage[index]
//                                       .booksReadCount ??
//                                   "",
//                               notesReadCount: _listMyReportsDetailPage[index]
//                                       .notesReadCount ??
//                                   "",
//                               practiceAttemptedCount:
//                                   _listMyReportsDetailPage[index]
//                                           .practiceAttempted ??
//                                       "",
//                               testsAttemptedCount:
//                                   _listMyReportsDetailPage[index]
//                                           .testsAttempted ??
//                                       "",
//                               videosWatchedCount:
//                                   _listMyReportsDetailPage[index]
//                                           .videosWatched ??
//                                       "",
//                               indexNumber: index,
//                               indexColor: (Constants.subjectColorAndImageMap[
//                                           widget.myReportsModel.subjectID] !=
//                                       null)
//                                   ? Constants.subjectColorAndImageMap[widget
//                                       .myReportsModel.subjectID]['subjectColor']
//                                   : 0xFFFCAC52,
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               : Center(
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     backgroundColor: Color(0xFF3399FF),
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
//
//   Widget reportHeaderTopWatchedRow({
//     String chapterName = "",
//     int count = 0,
//   }) {
//     return Expanded(
//       flex: 1,
//       child: Row(
//         children: [
//           Image.asset(
//             "assets/images/report_page_line_1.png",
//             height: ScreenUtil().setSp(65, ),
//           ),
//           SizedBox(
//             width: ScreenUtil().setSp(8, ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               RichText(
//                 text: TextSpan(
//                   style: TextStyle(
//                     color: Color(0xFF212121),
//                     fontSize:
//                         ScreenUtil().setSp(10, ),
//                     height: 1.8,
//                     fontFamily: GoogleFonts.inter().fontFamily,
//                   ),
//                   children: [
//                     TextSpan(
//                       text: 'You watched',
//                       style: TextStyle(
//                         fontWeight: FontWeight.values[4],
//                       ),
//                     ),
//                     TextSpan(
//                       text: ' $chapterName',
//                       style: TextStyle(
//                         fontWeight: FontWeight.values[5],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: ScreenUtil().setSp(8, ),
//               ),
//               Text(
//                 "$count Times",
//                 style: TextStyle(
//                   color: Color(0xFF212121),
//                   fontSize: ScreenUtil().setSp(14, ),
//                   // height: 1.8,
//                   fontWeight: FontWeight.values[5],
//                   fontFamily: GoogleFonts.inter().fontFamily,
//                 ),
//               ),
//               SizedBox(
//                 height: ScreenUtil().setSp(5, ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget reportHeaderOverAllMasteryRow({
//     String percentage = "0.0",
//   }) {
//     return Expanded(
//       flex: 1,
//       child: Row(
//         children: [
//           Image.asset(
//             "assets/images/report_page_line_2.png",
//             height: ScreenUtil().setSp(65, ),
//           ),
//           SizedBox(
//             width: ScreenUtil().setSp(8, ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 "Mastery",
//                 style: TextStyle(
//                   color: Color(0xFF212121),
//                   fontSize: ScreenUtil().setSp(10, ),
//                   height: 1.8,
//                   fontWeight: FontWeight.values[5],
//                 ),
//               ),
//               SizedBox(
//                 height: ScreenUtil().setSp(12, ),
//               ),
//               Text(
//                 "$percentage%",
//                 style: TextStyle(
//                   color: Color(0xFF212121),
//                   fontSize: ScreenUtil().setSp(14, ),
//                   // height: 1.8,
//                   fontWeight: FontWeight.values[5],
//                   fontFamily: GoogleFonts.inter().fontFamily,
//                 ),
//               ),
//               SizedBox(
//                 height: ScreenUtil().setSp(8, ),
//               ),
//               Container(
//                 width: ScreenUtil().setSp(118, ),
//                 alignment: Alignment.centerRight,
//                 child: LinearPercentIndicator(
//                   padding: EdgeInsets.all(0),
//                   backgroundColor: Color((Constants.subjectColorAndImageMap[
//                                   widget.myReportsModel.subjectID] !=
//                               null)
//                           ? Constants.subjectColorAndImageMap[
//                               widget.myReportsModel.subjectID]['subjectColor']
//                           : 0xFFFCAC52)
//                       .withOpacity(0.1),
//                   percent: double.parse(percentage) / 100,
//                   progressColor: Color((Constants.subjectColorAndImageMap[
//                               widget.myReportsModel.subjectID] !=
//                           null)
//                       ? Constants.subjectColorAndImageMap[
//                           widget.myReportsModel.subjectID]['subjectColor']
//                       : 0xFFFCAC52),
//                   leading: Container(),
//                 ),
//               ),
//               SizedBox(
//                 height: ScreenUtil().setSp(5, ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ExpandableTile extends StatefulWidget {
//   final String title;
//   final String videosWatchedCount;
//   final String practiceAttemptedCount;
//   final String testsAttemptedCount;
//   final String notesReadCount;
//   final String booksReadCount;
//   final int indexNumber;
//   final int indexColor;
//
//   ExpandableTile({
//     this.title,
//     this.videosWatchedCount = "0/0",
//     this.practiceAttemptedCount = "0",
//     this.testsAttemptedCount = "0",
//     this.notesReadCount = "0/0",
//     this.booksReadCount = "0/0",
//     this.indexNumber,
//     this.indexColor,
//   });
//
//   @override
//   _ExpandableTileState createState() => _ExpandableTileState();
// }
//
// class _ExpandableTileState extends State<ExpandableTile> {
//   bool _tileExpanded = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       childrenPadding: EdgeInsets.all(
//         ScreenUtil().setSp(0, ),
//       ),
//       expandedAlignment: Alignment.centerLeft,
//       tilePadding: EdgeInsets.all(0),
//       title: Row(
//         children: [
//           Text(
//             "${widget.indexNumber < 9 ? "0" : ""}${widget.indexNumber + 1}.",
//             style: TextStyle(
//               fontSize: ScreenUtil().setSp(12, ),
//               color: Color(widget.indexColor),
//             ),
//           ),
//           SizedBox(
//             width: ScreenUtil().setSp(14, ),
//           ),
//           Expanded(
//             child: Text(
//               widget.title,
//               style: TextStyle(
//                   fontSize: ScreenUtil().setSp(14, ),
//                   fontWeight: FontWeight.values[5],
//                   color: Color(0xFF212121)),
//             ),
//           ),
//         ],
//       ),
//       trailing: Image.asset(
//         "assets/images/${_tileExpanded ? "up_arrow" : "down_arrow"}.png",
//         height: ScreenUtil().setSp(24, ),
//         width: ScreenUtil().setSp(24, ),
//       ),
//       onExpansionChanged: (value) {
//         setState(() {
//           _tileExpanded = value;
//         });
//       },
//       children: <Widget>[
//         internalChildRow(
//           title: "Videos Watched",
//           dataText: widget.videosWatchedCount,
//         ),
//         internalChildRow(
//           title: "Practice Attempted",
//           dataText: widget.practiceAttemptedCount,
//         ),
//         internalChildRow(
//           title: "Tests Attempted",
//           dataText: widget.testsAttemptedCount,
//         ),
//         internalChildRow(
//           title: "Notes Read",
//           dataText: widget.notesReadCount,
//         ),
//         internalChildRow(
//           title: "Books Read",
//           dataText: widget.booksReadCount,
//         ),
//       ],
//     );
//   }
//
//   Widget internalChildRow({String title, String dataText}) {
//     return Padding(
//       padding: EdgeInsets.only(
//         left: ScreenUtil().setSp(30, ),
//         right: ScreenUtil().setSp(8, ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//                 fontSize: ScreenUtil().setSp(12, ),
//                 color: Color(0xFF666666),
//                 height: 1.6,
//                 letterSpacing: 0.1),
//           ),
//           Text(
//             dataText,
//             style: TextStyle(
//                 fontSize: ScreenUtil().setSp(12, ),
//                 color: Color(0xFF666666),
//                 height: 1.6,
//                 letterSpacing: 0.1),
//           ),
//         ],
//       ),
//     );
//   }
// }
