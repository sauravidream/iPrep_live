import 'package:flutter/material.dart';
import 'package:idream/model/batch_model.dart';
import 'package:idream/repository/board_selection_repository.dart';
import 'package:idream/repository/dashboard_repository.dart';
import 'package:idream/ui/dashboard/batches/assigned_student_tab.dart';
import 'package:idream/ui/dashboard/batches/message_student_tab.dart';

import '../../../common/references.dart';

class StudentBatchDetailsPage extends StatefulWidget {
  final Batch? batch;
  final int showTabIndex;

  const StudentBatchDetailsPage({Key? key,
    this.batch,
    this.showTabIndex = 0,
  }) : super(key: key);

  @override
  _StudentBatchDetailsPageState createState() =>
      _StudentBatchDetailsPageState();
}

class _StudentBatchDetailsPageState extends State<StudentBatchDetailsPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int? index;
  BoardSelectionRepository boardRepository = BoardSelectionRepository();
  DashboardRepository subjectRepository = DashboardRepository();

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        vsync: this, length: 2, initialIndex: widget.showTabIndex);
    tabController!.addListener(() {
      setState(() {
        index = tabController!.index;
      });
    });
    index = widget.showTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                // Scaffold.of(context).openDrawer();
                Navigator.of(context).pop();
              },
              icon: Row(
                children: [
                  Image.asset(
                    "assets/images/back_icon.png",
                    height: 24,
                    width: 24,
                  ),
                ],
              ),
            );
          },
        ),
        titleSpacing: -15,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              height: 36,
              width: 36,
              decoration: const BoxDecoration(
                  color: Color(0xffD1E6FF),
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Text(
                (widget.batch!.batchClass!.length > 2)
                    ? widget.batch!.batchClass!.substring(0, 2)
                    : widget.batch!.batchClass!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xff0070FF),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Flexible(flex: 1,
              child: Text(
                widget.batch!.batchName!,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Inter",
                    color: Color(0xff212121)),
              ),
            )
          ],
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size(double.maxFinite, 35.0),
          child: SizedBox(
            height: 35,
            child: TabBar(
              controller: tabController,
              isScrollable: true,
              indicatorColor: Colors.transparent,
              labelColor: Colors.black,
              labelPadding: const EdgeInsets.only(left: 27, right: 27),
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.values[5],
              ),
              unselectedLabelColor: const Color(0xFFC9C9C9),
              unselectedLabelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.values[5],
              ),
              tabs: [
                Tab(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Messages',
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      index == 0
                          ? Container(
                              width: 15, height: 4, color: const Color(0xff0070FF))
                          : Container()
                    ],
                  ),
                ),
                Tab(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Assigned',
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      index == 1
                          ? Container(
                              width: 15, height: 4, color: const Color(0xff0070FF))
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 0.5,
                color: const Color(0xFF6A6A6A),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .82,
              child: TabBarView(
                controller: tabController,
                children: [
                  ChatTabForStudent(
                    selectedBatchModel: widget.batch,
                  ),
                  StreamBuilder(
                    stream: dbRef
                        .child("/assignments/${widget.batch!}").onValue,
                    builder: (context, snapshot) {
                      return AssignedTabForStudent(
                        selectedBatch: widget.batch,
                      );
                    }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
