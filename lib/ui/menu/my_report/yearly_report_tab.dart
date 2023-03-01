import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:idream/model/my_reports_model.dart';
import 'package:idream/ui/menu/my_report/my_report_detailed_view_page.dart';
import '../my_reports_page.dart';

class YearlyReportTab extends StatelessWidget {
  final List<MyReportsModel>? listMyReportsModel;
  final Map? bookLibraryCompleteData;
  final Map? stemVideosCompleteData;
  final MyReportsPage? myReportsPage;

   const YearlyReportTab({Key? key,
    this.listMyReportsModel,
    this.bookLibraryCompleteData,
    this.stemVideosCompleteData,
    this.myReportsPage,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MyReportDetailedViewPage(
      listMyReportsModel: listMyReportsModel,
      viewName: "year",
      bookLibraryCompleteData: json.encode(bookLibraryCompleteData),
      stemVideosCompleteData: json.encode(stemVideosCompleteData),
      myReportsPage: myReportsPage,
    );
  }
}
