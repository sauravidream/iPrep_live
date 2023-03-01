import 'package:flutter/material.dart';
import 'package:idream/common/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/custom_widgets/custom_tile.dart';
import 'package:idream/custom_widgets/onboarding_bottom_button.dart';
import 'package:idream/model/boards_model.dart';
import 'package:idream/ui/menu/class_update_screen.dart';

class BoardUpdateScreen extends StatefulWidget {
  final int? classNumber;
  BoardUpdateScreen({this.classNumber});

  @override
  BoardUpdateScreenState createState() => BoardUpdateScreenState();
}

class BoardUpdateScreenState extends State<BoardUpdateScreen> {
  String? selectedEducationBoard;
  @override
  void initState() {
    // selectedEducationBoard = "CBSE";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset("assets/images/back_icon.png"),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(
                        bottom: 30,
                      ),
                      child: Text(
                        "Select your Board",
                        style: TextStyle(
                            color: const Color(0xFF212121),
                            fontSize: 16,
                            fontWeight: FontWeight.values[5]),
                      ),
                    ),
                    FutureBuilder(
                        future: boardSelectionRepository.fetchEducationBoards(),
                        builder: (context, boards) {
                          if (boards.connectionState == ConnectionState.none &&
                              boards.hasData == null) {
                            return Container();
                          } else if (boards.hasData) {
                            List<BoardsModel>? _boardsStandardList =
                                boards.data as List<BoardsModel>?;
                            return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _boardsStandardList!.length,
                                padding: const EdgeInsets.all(0),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (selectedEducationBoard ==
                                          _boardsStandardList[index].abbr) {
                                        setState(() {
                                          selectedEducationBoard = "";
                                        });
                                      } else {
                                        setState(() {
                                          selectedEducationBoard =
                                              _boardsStandardList[index].abbr;
                                        });
                                      }
                                    },
                                    child: CustomTileWidget(
                                      selected: (selectedEducationBoard ==
                                              _boardsStandardList[index].abbr)
                                          ? true
                                          : false,
                                      streamText:
                                          _boardsStandardList[index].boardName,
                                      leadingWidgetRequired: true,
                                      dynamicLeadingImagePath:
                                          _boardsStandardList[index].icon,
                                      // leadingImagePath:
                                      //     "assets/images/cbse_board.png",
                                    ),
                                  );
                                });
                          } else {
                            return Container(
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(),
                            );
                          }
                        }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: OnBoardingBottomButton(
                  topPadding: 5,
                  buttonText:
                      "Next" /*(widget.classNumber >= 11) ? "Next" : "Confirm"*/,
                  onPressed: () async {
                    // await userRepository.saveUserDetailToLocal(
                    //     "educationBoard", selectedEducationBoard);

                    if (selectedEducationBoard != null &&
                        selectedEducationBoard!.isNotEmpty) {
                      updatedAppUser.educationBoard = selectedEducationBoard;

                      await Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ClassUpdateScreen(
                            boardName: selectedEducationBoard,
                          ),
                        ),
                      );
                    } else {
                      SnackbarMessages.showErrorSnackbar(context,
                          error: Constants.boardSelectionAlert);
                    }

                    // String _classNumber =
                    //     await getStringValuesSF("classNumber");
                    // if (widget.classNumber < 11) {
                    //   // await Navigator.push(
                    //   //   context,
                    //   //   CupertinoPageRoute(
                    //   //     builder: (context) => DashboardScreen(),
                    //   //   ),
                    //   // );
                    //
                    //   profileEdited = true;
                    //   Navigator.pop(context);
                    //   Navigator.pop(context);
                    // } else {
                    //   await Navigator.push(
                    //     context,
                    //     CupertinoPageRoute(
                    //       builder: (context) => StreamUpdateScreen(),
                    //     ),
                    //   );
                    // }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
