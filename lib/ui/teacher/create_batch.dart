
import 'dart:io';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/custom_widgets/loader.dart';
import 'package:idream/custom_widgets/onboarding_bottom_button.dart';
import 'package:idream/model/boards_model.dart';
import 'package:idream/model/class_model.dart';
import 'package:idream/model/streams_model.dart';
import 'package:idream/model/subject_model.dart';
import 'package:idream/repository/batch_repository.dart';
import 'package:idream/repository/board_selection_repository.dart';
import 'package:idream/repository/class_repository.dart';
import 'package:idream/repository/dashboard_repository.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:random_string/random_string.dart';

class CreateBatch extends StatefulWidget {
  @override
  _CreateBatchState createState() => _CreateBatchState();
}

class _CreateBatchState extends State<CreateBatch> {
  bool _dataLoaded = false;
  final _textBoxHintAndTextStyle = const TextStyle(
    color: Color(0xFF212121),
    fontSize: 14,
  );
  final batchRepository = BatchRepository();
  String? selectClassId = "";
  String? selectStreamId = "";
  List<SubjectModel> selectSubject = [];
  String? selectBoard = "";
  String selectLanguage = "";
  bool tabBoard = false;
  int? tabClassIndex;
  List<bool> tabSubject = [];
  bool tabClass = false;
  bool tabLanguage = false;
  String? batchName = "",
      classId,
      className,
      subjectId,
      subjectName,
      batchId,
      teacherId,
      teacherName,
      batchCode,
      boardId;
  ClassRepository classRepository = new ClassRepository();

  List<ClassStandard>? _classesList = [];
  DashboardRepository subjectRepository = new DashboardRepository();

  List<SubjectModel>? _subjectList = [];
  List<StreamsModel>? _streamList = [];
  BoardSelectionRepository boardRepository = new BoardSelectionRepository();
  List<BoardsModel>? finalBoardList = [];
  List<dynamic>? finalLanguage = [];
  String subjectListText = "";

  Future getList() async {
    List<ClassStandard>? classesList = await (classRepository.fetchClasses() );
    List<BoardsModel>? _boardList = await (boardRepository.fetchEducationBoards() );
    List<dynamic>? languagelist = await (boardRepository.fetchLanuageList() );
    // setState(() {
    finalBoardList = _boardList;
    _classesList = classesList;
    finalLanguage = languagelist;
    // });
  }

  @override
  void initState() {
    super.initState();
    getList().then((value) {
      setState(() {
        _dataLoaded = true;
      });
    });
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
                Navigator.pop(context);
              },
              icon: Image.asset(
                "assets/images/back_icon.png",
                height: 25,
                width: 25,
              ),
            );
          },
        ),
        centerTitle: false,
      ),
      body: _dataLoaded
          ? SingleChildScrollView(
              child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 46,
                      ),
                      const Center(
                        child: Text(
                          "Create your Batch",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w500,
                              color: Color(0xff212121)),
                        ),
                      ),
                      getLabel(
                        topPadding: 30,
                        text: "Batch / Class Name",
                      ),
                      TextFormField(
                        autocorrect: false,
                        textInputAction: TextInputAction.done,
                        cursorColor: Colors.black87,
                        style: _textBoxHintAndTextStyle,
                        onChanged: (v) {
                          setState(() {
                            batchName = v;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Batch / Class Name",
                          hintStyle: _textBoxHintAndTextStyle,
                          focusedBorder: Constants.focusedTextOutline,
                          enabledBorder: Constants.inputTextOutline,
                          border: Constants.inputTextOutline,
                        ),
                      ),
                      getLabel(text: "Board"),
                      TextFormField(
                        autocorrect: false,
                        textInputAction: TextInputAction.done,
                        readOnly: true,
                        cursorColor: Colors.black87,
                        style: _textBoxHintAndTextStyle,
                        onTap: () {
                          showBoardBottomSheet(context);
                        },
                        initialValue: selectBoard,
                        decoration: InputDecoration(
                          hintText: selectBoard!.isNotEmpty
                              ? selectBoard
                              : "Select Board",
                          hintStyle: _textBoxHintAndTextStyle,
                          focusedBorder: Constants.focusedTextOutline,
                          enabledBorder: Constants.inputTextOutline,
                          border: Constants.inputTextOutline,
                        ),
                      ),
                      getLabel(text: "Language"),
                      TextFormField(
                        autocorrect: false,
                        textInputAction: TextInputAction.done,
                        readOnly: true,
                        cursorColor: Colors.black87,
                        style: _textBoxHintAndTextStyle,
                        onTap: () {
                          showSelectLanguageBottomSheet(context);
                        },
                        initialValue: selectLanguage,
                        decoration: InputDecoration(
                          hintText: selectLanguage.isNotEmpty
                              ? (selectLanguage.substring(0, 1).toUpperCase() +
                                  selectLanguage.toString().substring(
                                      1, selectLanguage.toString().length))
                              : "Select Language",
                          hintStyle: _textBoxHintAndTextStyle,
                          focusedBorder: Constants.focusedTextOutline,
                          enabledBorder: Constants.inputTextOutline,
                          border: Constants.inputTextOutline,
                        ),
                      ),
                      getLabel(text: "Class"),
                      TextFormField(
                        onTap: () {
                          showClassBottomSheet(context);
                        },
                        autocorrect: false,
                        style: _textBoxHintAndTextStyle,
                        textInputAction: TextInputAction.done,
                        // initialValue: selectClassId,
                        readOnly: true,
                        cursorColor: Colors.black87,
                        decoration: InputDecoration(
                          hintText: selectClassId!.isNotEmpty
                              ? selectClassId
                              : "Select Class",
                          hintStyle: _textBoxHintAndTextStyle,
                          focusedBorder: Constants.focusedTextOutline,
                          enabledBorder: Constants.inputTextOutline,
                          border: Constants.inputTextOutline,
                        ),
                      ),
                      if (selectClassId!.isNotEmpty &&
                          (int.parse(selectClassId!) > 10))
                        getLabel(text: "Stream"),
                      if (selectClassId!.isNotEmpty &&
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
                      getLabel(text: "Subject"),
                      TextFormField(
                        autocorrect: false,
                        textInputAction: TextInputAction.done,
                        readOnly: true,
                        style: _textBoxHintAndTextStyle,
                        onTap: () {
                          if (_subjectList != null) {
                            // ignore: unused_local_variable
                            for (var item in _subjectList!) {
                              tabSubject.add(false);
                            }
                          } else {
                            tabSubject.add(false);
                          }
                          showSubjectBottomSheet(context);
                        },
                        cursorColor: Colors.black87,
                        enabled: _subjectList != null ? true : false,
                        decoration: InputDecoration(
                          hintText: selectSubject.isNotEmpty
                              ? subjectListText
                              /*"${selectSubject[0].subjectName}"*/
                              : "Select Subjects",
                          hintStyle: _textBoxHintAndTextStyle,
                          focusedBorder: Constants.focusedTextOutline,
                          enabledBorder: Constants.inputTextOutline,
                          border: Constants.inputTextOutline,
                        ),
                      ),
                      OnBoardingBottomButton(
                        buttonText: "Create Batch",
                        topPadding: 40,
                        onPressed: () async {
                          if (batchName!.isNotEmpty &&
                              selectBoard!.isNotEmpty &&
                              selectLanguage.isNotEmpty &&
                              (selectClassId!.isNotEmpty ||
                                  (int.parse(selectClassId!) > 10) &&
                                      selectStreamId!.isNotEmpty) &&
                              selectSubject.isNotEmpty) {
                            var deeplink = await prepareDeepLink();
                            var _response = await batchRepository.saveBatchData(
                                language: selectLanguage,
                                board: selectBoard,
                                boardId: finalBoardList!
                                    .firstWhere((element) =>
                                        element.boardName == selectBoard)
                                    .abbr,
                                batchId: batchId!,
                                batchName: batchName,
                                batchCode: batchCode,
                                subjectList: selectSubject,
                                teacherId: teacherId,
                                teacherName: teacherName,
                                deeplink: deeplink.toString(),
                                classId: selectStreamId!.isNotEmpty
                                    ? selectStreamId
                                    : selectClassId);
                            if (_response != null && _response) {
                              Navigator.pop(context, _response);
                            } else {
                              SnackbarMessages.showErrorSnackbar(context,
                                  error: Constants.batchCreationError);
                            }
                          } else {
                            SnackbarMessages.showErrorSnackbar(context,
                                error: Constants.createBatchEntryFillAlert);
                          }
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ))
          : Center(
              child: Loader(),
            ),
    );
  }

  Container getLabel(
      {double topPadding = 20.0, double bottomPadding = 8, String text = ""}) {
    return Container(
      padding: EdgeInsets.only(
        top: topPadding,
        bottom: bottomPadding,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF9E9E9E),
        ),
      ),
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
                          tabSubject.fillRange(
                              0,
                              ((tabSubject.isNotEmpty)
                                  ? (tabSubject.length - 1)
                                  : 0),
                              false);
                          subjectListText = "";
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
                                      boardName: finalBoardList!
                                          .firstWhere((element) =>
                                              element.boardName == selectBoard)
                                          .abbr,
                                      classID: _classesList![index].classID) );
                            } else {
                              List<SubjectModel>? subjectList =
                                  await (subjectRepository.fetchSubjectList(
                                      batch: true,
                                      selectedClass:
                                          _classesList![index].classID,
                                      educationBoard: finalBoardList!
                                          .firstWhere((element) =>
                                              element.boardName == selectBoard)
                                          .abbr) );
                              _subjectList = subjectList;
                            }
                          }
                          setState(() {});
                          Navigator.pop(context);
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
                                          _classesList![index].className!.length -
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
                      itemCount: _subjectList == null ? 0 : _subjectList!.length,
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

                        selectStreamId = _streamList![index].streamID;

                        List<SubjectModel>? subjectList =
                            await (subjectRepository.fetchSubjectList(
                                batch: true,
                                selectedClass: selectStreamId,
                                educationBoard: finalBoardList!
                                    .firstWhere((element) =>
                                        element.boardName == selectBoard)
                                    .abbr) );
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

  buildSubjectValue(String? text, String? id, int index) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter _setState) {
        return InkWell(
          onTap: () async {
            subjectListText = "";
            if (tabSubject[index]) {
              selectSubject.removeWhere((element) => (element.subjectID == id));
              tabSubject[index] = false;
            } else {
              SubjectModel subjectModel = SubjectModel(
                subjectID: id,
                subjectName: text,
              );
              selectSubject.add(subjectModel);
              tabSubject[index] = true;
            }

            await Future.forEach(selectSubject, (dynamic element) {
              subjectListText += element.subjectName + ", ";
            });
            setState(() {});
            _setState(() {});
          },
          child: Container(
            height: 44,
            color: tabSubject[index] ? const Color(0xffE8F2FF) : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text!,
                    style: const TextStyle(fontSize: 14, color: Color(0xff212121)),
                  ),
                  Center(
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: tabSubject[index]
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

  generateBatchId() {
    return ("S" + randomAlphaNumeric(5).toUpperCase());
  }

  Future prepareDeepLink() async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    boardId =
        (await getStringValuesSF("educationBoard")).toString().toLowerCase();
    String _packageName = "org.idreameducation.iprepapp";

    teacherId = await getStringValuesSF("userID");
    teacherName = await getStringValuesSF("fullName");
    batchId = generateBatchId();
    String _storeUrl = Platform.isIOS
        ? Constants.appStoreUrl
        : "https://play.google.com/store/apps/details?id=org.idreameducation.iprepapp";
    var parameters = DynamicLinkParameters(
      uriPrefix: 'https://iprepteacher.page.link',
      link: Uri.parse(
          '$_storeUrl${Platform.isIOS ? "?" : "&"}&batchName=$batchName&batchId=$batchId&teacherId=$teacherId&teacherName=$teacherName'),
      androidParameters: AndroidParameters(
        packageName: _packageName,
      ),
      iosParameters: IOSParameters(
        bundleId: _packageName,
        appStoreId: '1532244186',
      ),
      socialMetaTagParameters: const SocialMetaTagParameters(
        title: "iPrep App",
        description: "Download the app now",
      ),
    );
    // var dynamicUrl = await parameters.buildUrl();
    final ShortDynamicLink shortLink =
    await dynamicLinks.buildShortLink(parameters);
  Uri  url = shortLink.shortUrl;
    // final ShortDynamicLink shortenedLink =
    //     await DynamicLinkParameters.shortenUrl(
    //   dynamicUrl,
    //   DynamicLinkParametersOptions(
    //       shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short),
    // );

    var _shortUrl = url;
    print(_shortUrl);
    batchCode =
        _shortUrl.toString().replaceAll("https://iprepteacher.page.link/", "");

    return _shortUrl;
  }

  showBoardBottomSheet(BuildContext context) {
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
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0)),
                ),
                child: SingleChildScrollView(
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
                          "Select Board",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Inter",
                              color: Color(0xff666666)),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 16),
                        itemCount:
                            finalBoardList == null ? 0 : finalBoardList!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (selectBoard ==
                                    finalBoardList![index].boardName) {
                                  selectBoard = "";
                                } else {
                                  selectBoard = finalBoardList![index].boardName;
                                }
                                Navigator.pop(context);
                              });
                            },
                            child: Container(
                              height: 44,
                              color: (selectBoard ==
                                      finalBoardList![index].boardName)
                                  ? const Color(0xffE8F2FF)
                                  : Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      finalBoardList![index].boardName!,
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
                                        child: selectBoard ==
                                                finalBoardList![index].boardName
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
        });
  }

  showSelectLanguageBottomSheet(BuildContext context) {
    return showMaterialModalBottomSheet(
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
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)),
              ),
              child: SingleChildScrollView(
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
                        "Select Language",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff666666),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: finalLanguage!.length,
                      padding: const EdgeInsets.only(top: 16),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (selectLanguage ==
                                  finalLanguage![index].toString()) {
                                selectLanguage = "";
                              } else {
                                selectLanguage =
                                    finalLanguage![index].toString();
                              }
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 44,
                            color: (selectLanguage ==
                                    finalLanguage![index].toString())
                                ? const Color(0xffE8F2FF)
                                : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    finalLanguage![index]
                                            .toString()
                                            .substring(0, 1)
                                            .toUpperCase() +
                                        finalLanguage![index]
                                            .toString()
                                            .substring(
                                                1,
                                                finalLanguage![index]
                                                    .toString()
                                                    .length),
                                    style: const TextStyle(
                                        fontSize: 14, color: Color(0xff212121)),
                                  ),
                                  Center(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: (selectLanguage ==
                                              finalLanguage![index].toString())
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
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
