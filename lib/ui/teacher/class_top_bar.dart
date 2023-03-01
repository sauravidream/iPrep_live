import 'package:flutter/material.dart';
import 'package:idream/provider/network_provider.dart';
import 'package:idream/ui/network_error_page.dart';
import 'package:provider/provider.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/custom_widgets/onboarding_bottom_button.dart';
import 'package:idream/model/batch_model.dart';
import 'package:idream/model/boards_model.dart';
import 'package:idream/model/class_model.dart';
import 'package:idream/model/streams_model.dart';
import 'package:idream/model/subject_model.dart';
import 'package:idream/repository/batch_repository.dart';
import 'package:idream/repository/board_selection_repository.dart';
import 'package:idream/repository/dashboard_repository.dart';
import 'package:idream/ui/teacher/class_tab_bar/assigned.dart';
import 'package:idream/ui/teacher/class_tab_bar/message.dart';
import 'package:idream/ui/teacher/class_tab_bar/student.dart';
import 'package:idream/ui/teacher/dashboard_coach.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';

class ClassTopBar extends StatefulWidget {
  final DashboardCoachState? dashboardOneState;
  final Batch? batch;

  const ClassTopBar({
    Key? key,
    this.batch,
    this.dashboardOneState,
  }) : super(key: key);

  @override
  _ClassTopBarState createState() => _ClassTopBarState();
}

class _ClassTopBarState extends State<ClassTopBar>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int index = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3);
    tabController!.addListener(() {
      setState(() {
        index = tabController!.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkProvider>(
      builder: (BuildContext context, NetworkProvider networkProvider,
          Widget? child) {
        return networkProvider.isAvailable == true
            ? Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  leading: Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        onPressed: () {
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
                              fontFamily: "Inter",
                              color: Color(0xff0070FF)),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        flex: 1,
                        child: Text(
                          widget.batch!.batchName!,
                          overflow: TextOverflow.ellipsis,
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
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () async {
                          await showEditBottomSheet(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "View Details",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff0070FF),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size(double.maxFinite, 35.0),
                    child: SizedBox(
                      height: 35,
                      child: TabBar(
                        controller: tabController,
                        isScrollable: true,
                        indicatorColor: Colors.transparent,
                        labelColor: Colors.black,
                        labelPadding:
                            const EdgeInsets.only(left: 27, right: 27),
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
                                  style: TextStyle(
                                      fontFamily: "Inter",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                index == 0
                                    ? Container(
                                        width: 15,
                                        height: 4,
                                        color: const Color(0xff0070FF))
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
                                style: TextStyle(
                                    fontFamily: "Inter",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              index == 1
                                  ? Container(
                                      width: 15,
                                      height: 4,
                                      color: const Color(0xff0070FF))
                                  : Container()
                            ],
                          )),
                          Tab(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Students',
                                style: TextStyle(
                                    fontFamily: "Inter",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              index == 2
                                  ? Container(
                                      width: 15,
                                      height: 4,
                                      color: const Color(0xff0070FF))
                                  : Container()
                            ],
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: PreferredSize(
                          preferredSize: const Size.fromHeight(1),
                          child: Container(
                            height: 0.5,
                            color: const Color(0xFF6A6A6A),
                          ),
                        ),
                      ),
                      // TabBar(
                      //     controller: tabController,
                      //     isScrollable: true,
                      //     indicatorColor: Colors.transparent,
                      //     labelColor: Colors.black,
                      //     labelPadding: EdgeInsets.only(left: 27, right: 27),
                      //     unselectedLabelColor: Colors.grey.withOpacity(0.5),
                      //     onTap: (v) {
                      //       setState(
                      //         () {
                      //           index = v;
                      //         },
                      //       );
                      //     },
                      //     tabs: [
                      //     ]),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .82,
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            ChatTab(
                              selectedBatchModel: widget.batch,
                            ),
                            Assigned(
                              selectedBatch: widget.batch,
                            ),
                            Student(
                              batchInfo: widget.batch,
                              dashboardOneState: widget.dashboardOneState,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const NetworkError();
      },
    );
  }

  showEditBottomSheet(BuildContext context) {
    showMaterialModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      context: context,
      builder: (context) {
        return UpdateBottomSheetPage(
          batchInfo: widget.batch,
        );
      },
    );
  }
}

class UpdateBottomSheetPage extends StatefulWidget {
  final Batch? batchInfo;
  const UpdateBottomSheetPage({this.batchInfo});

  @override
  _UpdateBottomSheetPageState createState() => _UpdateBottomSheetPageState();
}

class _UpdateBottomSheetPageState extends State<UpdateBottomSheetPage> {
  final TextEditingController _batchNameController = TextEditingController();
  final TextEditingController _boardController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _classController = TextEditingController();

  String? selectClassId = "";
  final _textBoxHintAndTextStyle = const TextStyle(
    color: Color(0xFF212121),
    fontSize: 14,
  );
  final batchRepository = new BatchRepository();
  BoardSelectionRepository boardRepository = new BoardSelectionRepository();
  DashboardRepository dashboardRepository = new DashboardRepository();
  // Batch _batch;
  late bool _editable;

  List<StreamsModel>? _streamList = [];
  List<dynamic>? _finalLanguage = [];
  List<SubjectModel>? _subjectList = [];
  final List<bool> _tabSubject = [];
  List<BoardsModel> _finalBoardList = [];
  List<ClassStandard>? _classesList = [];
  String subjectListText = "";
  String? selectStreamId = "";
  // String selectBoard = "";
  List<SubjectModel> selectSubject = [];
  getList() async {
    List<BoardsModel>? _boardList =
        await (boardRepository.fetchEducationBoards());
    List<SubjectModel>? subjectList =
        await (dashboardRepository.fetchSubjectList(
            selectedClass: widget.batchInfo!.batchClass,
            batch: true,
            educationBoard: _boardList!
                .firstWhere(
                    (element) => element.boardName == widget.batchInfo!.board)
                .abbr));
    List<dynamic>? languagelist = await (boardRepository.fetchLanuageList());
    List<ClassStandard>? classesList = await (classRepository.fetchClasses());

    selectSubject.clear();

    // setState(() {
    _finalBoardList = _boardList;
    _subjectList = subjectList;
    _finalLanguage = languagelist;
    _classesList = classesList;
    // });
    for (var item in _subjectList!) {
      _tabSubject.add(false);
    }
    if (widget.batchInfo!.batchClass!.length > 2) {
      selectStreamId = widget.batchInfo!.batchClass;
      _streamList = await (streamSelectionRepository.fetchStreams(
          boardName: _finalBoardList
              .firstWhere(
                  (element) => element.boardName == widget.batchInfo!.board)
              .abbr,
          classID: widget.batchInfo!.batchClass));
    }
    await Future.forEach(widget.batchInfo!.batchSubject!, (dynamic subject) {
      selectSubject.add(subject);
      _tabSubject[subjectList!.indexWhere(
          (element) => element.subjectID == subject.subjectID)] = true;
    });
    await Future.forEach(selectSubject, (dynamic element) {
      subjectListText += element.subjectName + ", ";
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // _batch = widget.batchInfo;
    getList();
    _editable = false;
    _batchNameController.text = widget.batchInfo!.batchName!;
    _boardController.text = widget.batchInfo!.board!;
    _languageController.text = widget.batchInfo!.language!;
    _classController.text = widget.batchInfo!.batchClass!;
    selectClassId = (widget.batchInfo!.batchClass!.length > 2
        ? widget.batchInfo!.batchClass!.substring(0, 2)
        : widget.batchInfo!.batchClass);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      height: MediaQuery.of(context).size.height * .80,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16,
        ),
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    height: 3,
                    width: 40,
                    color: const Color(0xffDEDEDE),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    _editable ? "Edit" : "Batch Details",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontSize: 16,
                        fontFamily: "Inter",
                        color: Color(0xff666666)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                    top: 12,
                  ),
                  child: const Text(
                    "Batch / Class Name",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF767676),
                    ),
                  ),
                ),
                // TextFormField(
                //   autocorrect: false,
                //   textInputAction: TextInputAction.done,
                //   initialValue: _batch.batchName,
                //   cursorColor: Colors.black87,
                //   onChanged: (v) {
                //     _batch.batchName = v;
                //   },
                //   decoration: InputDecoration(
                //     hintText: "Batch / Class Name",
                //     hintStyle: _textBoxHintAndTextStyle,
                //     focusedBorder: Constants.focusedTextOutline,
                //     enabledBorder: Constants.inputTextOutline,
                //     border: Constants.inputTextOutline,
                //   ),
                // ),
                updateBatchTextBoxController(
                  textEditingController: _batchNameController,
                  readOnly: !_editable,
                  hintText: "Batch / Class Name",
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: const Text(
                    "Board",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF767676),
                    ),
                  ),
                ),
                TextFormField(
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  readOnly: true,
                  style: _textBoxHintAndTextStyle,
                  // initialValue: _batch.board,
                  onTap: () async {
                    if (_editable) await showBoardBottomSheet(context, this);
                  },
                  cursorColor: Colors.black87,
                  controller: _boardController,
                  decoration: InputDecoration(
                    hintText: "Board",
                    hintStyle: _textBoxHintAndTextStyle,
                    focusedBorder: Constants.focusedTextOutline,
                    enabledBorder: Constants.inputTextOutline,
                    border: Constants.inputTextOutline,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: const Text(
                    "Language",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF767676),
                    ),
                  ),
                ),
                TextFormField(
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  readOnly: true,
                  cursorColor: Colors.black87,
                  controller: _languageController,
                  onTap: () {
                    if (_editable) {
                      showMaterialModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0)),
                        ),
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter _setState) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * .30,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: Container(
                                          height: 3,
                                          width: 40,
                                          color: const Color(0xffDEDEDE),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Center(
                                        child: Text(
                                          "Select a Language",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Inter",
                                              color: Color(0xff666666)),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: _finalLanguage!.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.all(3),
                                              child: InkWell(
                                                onTap: () {
                                                  _setState(() {
                                                    if (_languageController
                                                            .text ==
                                                        _finalLanguage![index]
                                                            .toString()) {
                                                      _languageController.text =
                                                          "";
                                                    } else {
                                                      _languageController.text =
                                                          _finalLanguage![index]
                                                              .toString();
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  color: _languageController
                                                              .text ==
                                                          _finalLanguage![index]
                                                              .toString()
                                                      ? const Color(0xffE8F2FF)
                                                      : Colors.white,
                                                  padding:
                                                      const EdgeInsets.all(6),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          _finalLanguage![index]
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  "Inter",
                                                              color: Color(
                                                                  0xff212121)),
                                                        ),
                                                        Center(
                                                            child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(6.0),
                                                            child: _languageController
                                                                        .text ==
                                                                    _finalLanguage![
                                                                            index]
                                                                        .toString()
                                                                ? Image.asset(
                                                                    'assets/images/checked_image_blue.png',
                                                                    height: 22,
                                                                    width: 22,
                                                                  )
                                                                : const SizedBox(
                                                                    height: 22,
                                                                    width: 22),
                                                          ),
                                                        )),
                                                      ]),
                                                ),
                                              ),
                                            );
                                          })
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                        },
                      );
                    }
                  },
                  // initialValue: _batch.language,
                  decoration: InputDecoration(
                    hintText: "Language",
                    focusedBorder: Constants.inputTextOutline,
                    enabledBorder: Constants.inputTextOutline,
                    border: Constants.inputTextOutline,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: const Text(
                    "Class",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF767676),
                    ),
                  ),
                ),
                TextFormField(
                  onTap: () {
                    if (_editable) showClassBottomSheet(context);
                  },
                  autocorrect: false,
                  style: _textBoxHintAndTextStyle,
                  textInputAction: TextInputAction.done,
                  // initialValue: selectClassId,
                  readOnly: true,
                  cursorColor: Colors.black87,
                  decoration: InputDecoration(
                    hintText: selectClassId!.isNotEmpty
                        ? ((selectClassId!.length > 2)
                            ? selectClassId!.substring(0, 2)
                            : selectClassId)
                        : "Select Class",
                    hintStyle: _textBoxHintAndTextStyle,
                    focusedBorder: Constants.focusedTextOutline,
                    enabledBorder: Constants.inputTextOutline,
                    border: Constants.inputTextOutline,
                  ),
                ),

                if (selectStreamId!.isNotEmpty ||
                    (int.parse(selectClassId!) > 10))
                  Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 12,
                    ),
                    child: const Text(
                      "Stream",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF767676),
                      ),
                    ),
                  ),

                if (selectStreamId!.isNotEmpty ||
                    (int.parse(selectClassId!) > 10))
                  TextFormField(
                    autocorrect: false,
                    textInputAction: TextInputAction.done,
                    readOnly: true,
                    style: _textBoxHintAndTextStyle,
                    onTap: () {
                      showStreamBottomSheet(context);
                    },
                    cursorColor: Colors.black87,
                    enabled: (_streamList!.isNotEmpty) ? true : false,
                    decoration: InputDecoration(
                      hintText: (_streamList != null &&
                              _streamList!.isNotEmpty &&
                              selectStreamId!.isNotEmpty)
                          ? _streamList!
                              .firstWhere((element) =>
                                  element.streamID == selectStreamId)
                              .streamName
                          : "Select Stream",
                      hintStyle: _textBoxHintAndTextStyle,
                      focusedBorder: Constants.focusedTextOutline,
                      enabledBorder: Constants.inputTextOutline,
                      border: Constants.inputTextOutline,
                    ),
                  ),

                // TextFormField(
                //   autocorrect: false,
                //   textInputAction: TextInputAction.done,
                //   initialValue: widget.batchInfo.batchClass,
                //   readOnly: true,
                //   cursorColor: Colors.black87,
                //   decoration: InputDecoration(
                //     hintText: "Class",
                //     focusedBorder: Constants.inputTextOutline,
                //     enabledBorder: Constants.inputTextOutline,
                //     border: Constants.inputTextOutline,
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: const Text(
                    "Subject",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF767676),
                    ),
                  ),
                ),
                TextFormField(
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  // initialValue: widget.batchInfo.batchSubject
                  //     .map((e) => e.subjectName)
                  //     .toString(),
                  readOnly: true,
                  cursorColor: Colors.black87,
                  onTap: () {
                    if (_editable) {
                      if (_tabSubject.isNotEmpty) {
                        if (_subjectList != null) {
                          // ignore: unused_local_variable
                          for (var item in _subjectList!) {
                            _tabSubject.add(false);
                          }
                        } else {
                          _tabSubject.add(false);
                        }
                      }
                      showSubjectBottomSheet(context);
                      // if (_subjectList != null) {
                      //   // ignore: unused_local_variable
                      //   for (var item in _subjectList) {
                      //     _tabSubject.add(false);
                      //   }
                      // } else {
                      //   _tabSubject.add(false);
                      // }
                      // showSubjectBottomSheet(context);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: selectSubject.isNotEmpty
                        ? subjectListText
                        /*"${selectSubject[0].subjectName}"*/
                        : "Select Subjects",
                    focusedBorder: Constants.inputTextOutline,
                    enabledBorder: Constants.inputTextOutline,
                    border: Constants.inputTextOutline,
                  ),
                ),
                OnBoardingBottomButton(
                  buttonText: _editable ? "Save Changes" : "Edit Details",
                  topPadding: 24,
                  onPressed: () async {
                    if (_editable) {
                      if (_batchNameController.text.isNotEmpty &&
                          _boardController.text.isNotEmpty &&
                          _languageController.text.isNotEmpty &&
                          _classController.text.isNotEmpty &&
                          selectSubject.isNotEmpty) {
                        Batch _batch = Batch(
                          batchName: _batchNameController.text,
                          board: _boardController.text,
                          language: _languageController.text,
                          batchClass: selectStreamId!.isNotEmpty
                              ? selectStreamId
                              : (selectClassId ?? _classController.text),
                          batchSubject: selectSubject,
                          batchId: widget.batchInfo!.batchId,
                        );
                        var _response =
                            await batchRepository.updateBatch(_batch);
                        if (_response) {
                          Navigator.pop(context);
                          Navigator.pop(context, true);
                        } else {
                          Navigator.pop(context);
                          SnackbarMessages.showErrorSnackbar(context,
                              error: Constants.batchUpdationError);
                        }
                      } else {
                        SnackbarMessages.showErrorSnackbar(context,
                            error: Constants.batchUpdationEntryFillAlert);
                      }
                    } else {
                      setState(() {
                        _editable = !_editable;
                      });
                    }
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                if (_editable)
                  InkWell(
                    onTap: () async {
                      await batchRepository.deleteBatch(widget.batchInfo!).then(
                        (value) async {
                          await Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  const DashboardCoach(),
                            ),
                          );
                        },
                      );
                    },
                    child: const Center(
                      child: Text(
                        "Delete Class",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xffFF0909),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showStreamBottomSheet(BuildContext context) async {
    showMaterialModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/line.png",
                    width: 40,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Text(
                    "Select Stream",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16, color: Color(0xff666666)),
                  ),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 16),
                  itemCount: _streamList == null ? 0 : _streamList!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        // setState(() {
                        //   // if (selectStreamId ==
                        //   //     _streamList[index].boardName) {
                        //   //   selectBoard = "";
                        //   // } else {
                        //   //   selectBoard = finalBoardList[index].boardName;
                        //   // }
                        //
                        // });
                        _tabSubject.fillRange(
                            0,
                            ((_tabSubject.isNotEmpty)
                                ? (_tabSubject.length - 1)
                                : 0),
                            false);
                        subjectListText = "";
                        selectSubject.clear();
                        selectStreamId = _streamList![index].streamID;

                        List<SubjectModel>? subjectList =
                            await (dashboardRepository.fetchSubjectList(
                                batch: true,
                                selectedClass: selectStreamId,
                                educationBoard: _finalBoardList
                                    .firstWhere((element) =>
                                        element.boardName ==
                                        widget.batchInfo!.board)
                                    .abbr));
                        _subjectList = subjectList;
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 44,
                        color: (selectStreamId == _streamList![index].streamID)
                            ? const Color(0xffE8F2FF)
                            : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _streamList![index].streamName!,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Inter",
                                    color: Color(0xff212121)),
                              ),
                              Center(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: selectStreamId ==
                                          _streamList![index].streamName
                                      ? Image.asset(
                                          'assets/images/checked_image_blue.png',
                                          height: 22,
                                          width: 22,
                                        )
                                      : const SizedBox(height: 22, width: 22),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showClassBottomSheet(BuildContext context) async {
    showMaterialModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter _setState) {
          return Container(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/line.png",
                    width: 40,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Text(
                    "Select Class",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16, color: Color(0xff666666)),
                  ),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 16),
                    itemCount: _classesList!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          _tabSubject.fillRange(
                              0,
                              ((_tabSubject.isNotEmpty)
                                  ? (_tabSubject.length - 1)
                                  : 0),
                              false);
                          subjectListText = "";
                          selectStreamId = "";
                          selectSubject.clear();
                          if (selectClassId == _classesList![index].classID) {
                            selectClassId = "";
                            _subjectList = null;
                          } else {
                            selectClassId = _classesList![index].classID;

                            if (selectClassId!.isNotEmpty &&
                                int.parse(selectClassId!) > 10) {
                              _streamList =
                                  await (streamSelectionRepository.fetchStreams(
                                      boardName: _finalBoardList
                                          .firstWhere((element) =>
                                              element.boardName ==
                                              _boardController.text)
                                          .abbr,
                                      classID: _classesList![index].classID));
                            } else {
                              List<SubjectModel>? subjectList =
                                  await (dashboardRepository.fetchSubjectList(
                                      batch: true,
                                      selectedClass:
                                          _classesList![index].classID,
                                      educationBoard: _finalBoardList
                                          .firstWhere((element) =>
                                              element.boardName ==
                                              _boardController.text)
                                          .abbr));
                              _subjectList = subjectList;
                            }
                          }
                          setState(() {});
                          Navigator.pop(context);
                          // if (selectClassId == _classesList[index].classID) {
                          //   selectClassId = "";
                          //   _subjectList = null;
                          // } else {
                          //   selectClassId = _classesList[index].classID;
                          //   List<SubjectModel> subjectList =
                          //       await dashboardRepository.fetchSubjectList(
                          //           selectedClass: _classesList[index].classID);
                          //   _subjectList = subjectList;
                          // }
                          // setState(() {});
                          // Navigator.pop(context);
                        },
                        child: Container(
                          height: 44,
                          color: selectClassId == _classesList![index].classID
                              ? const Color(0xffE8F2FF)
                              : Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Class " +
                                      _classesList![index].className!.substring(
                                          0,
                                          _classesList![index]
                                                  .className!
                                                  .length -
                                              2),
                                  style: const TextStyle(
                                      fontSize: 14, color: Color(0xff212121)),
                                ),
                                Center(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: selectClassId ==
                                            _classesList![index].classID
                                        ? Image.asset(
                                            'assets/images/checked_image_blue.png',
                                            height: 22,
                                            width: 22,
                                          )
                                        : const SizedBox(height: 22, width: 22),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }

  updateBatchTextBoxController({
    TextEditingController? textEditingController,
    Function? onTap,
    String? initialValue,
    String? hintText,
    bool readOnly = false,
  }) {
    return TextFormField(
      autocorrect: false,
      textInputAction: TextInputAction.done,
      readOnly: readOnly,
      style: _textBoxHintAndTextStyle,
      controller: textEditingController,
      initialValue: initialValue,
      onTap: onTap as void Function()?,
      cursorColor: Colors.black87,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: _textBoxHintAndTextStyle,
        focusedBorder: Constants.focusedTextOutline,
        enabledBorder: Constants.inputTextOutline,
        border: Constants.inputTextOutline,
      ),
    );
  }

  // showSubjectBottomSheet(BuildContext context) async {
  //   showMaterialModalBottomSheet(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
  //     ),
  //     context: context,
  //     builder: (context) {
  //       return Container(
  //         height: MediaQuery.of(context).size.height * .30,
  //         child: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Center(
  //                   child: Container(
  //                     height: 3,
  //                     width: 40,
  //                     color: Color(0xffDEDEDE),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 20,
  //                 ),
  //                 Center(
  //                   child: Text(
  //                     "Select a Subject",
  //                     textAlign: TextAlign.left,
  //                     style: TextStyle(
  //                         fontSize: 16,
  //                         fontFamily: "Inter",
  //                         color: Color(0xff666666)),
  //                   ),
  //                 ),
  //                 SizedBox(height: 10),
  //                 if (_subjectList == null)
  //                   buildSubjectValue("Physics", "1", 0)
  //                 else
  //                   ListView.builder(
  //                       shrinkWrap: true,
  //                       itemCount:
  //                           _subjectList == null ? 0 : _subjectList.length,
  //                       itemBuilder: (context, index) {
  //                         return buildSubjectValue(
  //                             _subjectList[index].subjectName,
  //                             _subjectList[index].subjectID,
  //                             index);
  //                       }),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  showSubjectBottomSheet(BuildContext context) async {
    showMaterialModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/line.png",
                    width: 40,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    const Center(
                      child: Text(
                        "Select Subjects",
                        textAlign: TextAlign.left,
                        style:
                            TextStyle(fontSize: 16, color: Color(0xff666666)),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Done",
                            style: TextStyle(
                                fontSize: 16,
                                color: const Color(0xff0077FF),
                                fontWeight: FontWeight.values[5]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (_subjectList == null)
                  buildSubjectValue("Physics", "1", 0)
                else
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 16),
                      itemCount:
                          _subjectList == null ? 0 : _subjectList!.length,
                      itemBuilder: (context, index) {
                        return buildSubjectValue(
                            _subjectList![index].subjectName,
                            _subjectList![index].subjectID,
                            index);
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  buildSubjectValue(String? text, String? id, int index) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter _setState) {
        return InkWell(
          onTap: () async {
            subjectListText = "";
            if (_tabSubject[index]) {
              selectSubject.removeWhere((element) => (element.subjectID == id));
              _tabSubject[index] = false;
            } else {
              SubjectModel subjectModel = SubjectModel(
                subjectID: id,
                subjectName: text,
              );
              selectSubject.add(subjectModel);
              _tabSubject[index] = true;
            }

            await Future.forEach(selectSubject, (dynamic element) {
              subjectListText += element.subjectName + ", ";
            });
            setState(() {});
            _setState(() {});
          },
          child: Container(
            height: 44,
            color: _tabSubject[index] ? const Color(0xffE8F2FF) : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text!,
                    style:
                        const TextStyle(fontSize: 14, color: Color(0xff212121)),
                  ),
                  Center(
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: _tabSubject[index]
                          ? Image.asset(
                              'assets/images/checked_image_blue.png',
                              height: 22,
                              width: 22,
                            )
                          : const SizedBox(height: 22, width: 22),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // buildSubjectValue(String text, String id, int index) {
  //   return StatefulBuilder(
  //       builder: (BuildContext context, StateSetter _setState) {
  //     return Padding(
  //       padding: EdgeInsets.all(3),
  //       child: InkWell(
  //         onTap: () {
  //           widget.batchInfo.batchSubject = [];
  //           SubjectModel subjectModel = new SubjectModel();
  //           _setState(() {
  //             if (_tabSubject[index]) {
  //               widget.batchInfo.batchSubject.remove(subjectModel);
  //               _tabSubject[index] = false;
  //             } else {
  //               subjectModel.subjectID = id;
  //               subjectModel.subjectName = text;
  //               widget.batchInfo.batchSubject.add(subjectModel);
  //
  //               _tabSubject[index] = true;
  //             }
  //           });
  //         },
  //         child: Container(
  //           color: _tabSubject[index] ? Color(0xffE8F2FF) : Colors.white,
  //           padding: EdgeInsets.all(6),
  //           child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   text,
  //                   style: TextStyle(
  //                       fontSize: 14,
  //                       fontFamily: "Inter",
  //                       color: Color(0xff212121)),
  //                 ),
  //                 Center(
  //                     child: Container(
  //                   decoration: BoxDecoration(
  //                     shape: BoxShape.circle,
  //                   ),
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(6.0),
  //                     child: _tabSubject[index]
  //                         ? Image.asset(
  //                             'assets/images/checked_image_blue.png',
  //                             height: 22,
  //                             width: 22,
  //                           )
  //                         : Container(height: 22, width: 22),
  //                   ),
  //                 )),
  //               ]),
  //         ),
  //       ),
  //     );
  //   });
  // }

  showBoardBottomSheet(BuildContext context,
      _UpdateBottomSheetPageState _updateBottomSheetPageState) {
    showMaterialModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter _setState) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .60,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        height: 3,
                        width: 40,
                        color: const Color(0xffDEDEDE),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Center(
                      child: Text(
                        "Select a Board",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Color(0xff666666)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          _finalBoardList == null ? 0 : _finalBoardList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(3),
                          child: InkWell(
                            onTap: () {
                              _setState(() {
                                if (_boardController.text ==
                                    _finalBoardList[index].boardName) {
                                  _boardController.text = "";
                                } else {
                                  _boardController.text =
                                      _finalBoardList[index].boardName!;
                                }
                              });

                              // _updateBottomSheetPageState.setState(() {
                              //   if (_batch.board ==
                              //       _finalBoardList[index].boardName) {
                              //     _batch.board = "";
                              //   } else {
                              //     _batch.board =
                              //         _finalBoardList[index].boardName;
                              //   }
                              // });
                            },
                            child: Container(
                              color: _boardController.text ==
                                      _finalBoardList[index].boardName
                                  ? const Color(0xffE8F2FF)
                                  : Colors.white,
                              padding: const EdgeInsets.all(6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _finalBoardList[index].boardName!,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Inter",
                                        color: Color(0xff212121)),
                                  ),
                                  Center(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: _boardController.text ==
                                                _finalBoardList[index].boardName
                                            ? Image.asset(
                                                'assets/images/checked_image_blue.png',
                                                height: 22,
                                                width: 22,
                                              )
                                            : const SizedBox(
                                                height: 22, width: 22),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
