import 'package:flutter/material.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/custom_widgets/custom_tile.dart';
import 'package:idream/custom_widgets/onboarding_bottom_button.dart';
import 'package:idream/model/boards_model.dart';
import 'package:idream/ui/onboarding/name_class_selection_screen.dart';
import 'package:flutter/cupertino.dart';
import '../../common/global_variables.dart';

class BoardSelectionScreen extends StatefulWidget {
  final int? classNumber;
  final String? language;
  const BoardSelectionScreen({Key? key, this.classNumber, this.language})
      : super(key: key);

  @override
  BoardSelectionScreenState createState() => BoardSelectionScreenState();
}

class BoardSelectionScreenState extends State<BoardSelectionScreen> {
  String? selectedEducationBoard;
  @override
  void initState() {
    selectedEducationBoard = widget.language;
    selectedEducationBoard = widget.language;
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
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(
                    bottom: 40,
                    left: 18,
                    right: 18,
                  ),
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(
                        bottom: 30,
                      ),
                      child: Text(
                        selectedAppLanguage!.toLowerCase() == "hindi"
                            ? "अपना बोर्ड चुनें"
                            : "Select your Board",
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
                                physics: NeverScrollableScrollPhysics(),
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
                              child: const Text("Loading..."),
                            );
                          }
                        }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 20,
                  left: 18,
                  right: 18,
                ),
                child: OnBoardingBottomButton(
                  buttonText: selectedAppLanguage!.toLowerCase() == "hindi"
                      ? "आगे बढ़ें"
                      : "Next" /*(widget.classNumber >= 11) ? "Next" : "Study Now"*/,
                  buttonColor: (selectedEducationBoard != null &&
                          selectedEducationBoard!.isNotEmpty)
                      ? 0xFF0077FF
                      : 0xFFDEDEDE,
                  onPressed: () async {
                    if (selectedEducationBoard != null &&
                        selectedEducationBoard!.isNotEmpty) {
                      String? _userFullName =
                          await getStringValuesSF("fullName");
                      String? _email = await getStringValuesSF("email");
                      await addStringToSF(
                          "educationBoard", selectedEducationBoard!);

                      if (_email == "null") {
                        _email = '';
                      }
                      if (_userFullName == "null") {
                        _userFullName = '';
                      }
                      if (!mounted) return;
                      await Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => NameClassSelectionScreen(
                              email: _email, userFullName: _userFullName),
                        ),
                      );
                    }
                    // await userRepository.saveUserDetailToLocal(
                    //     "educationBoard", selectedEducationBoard);
                    //
                    // String _classNumber =
                    //     await getStringValuesSF("classNumber");
                    // if (int.parse(_classNumber) < 11) {
                    //   await Navigator.push(
                    //     context,
                    //     CupertinoPageRoute(
                    //       builder: (context) => DashboardScreen(),
                    //     ),
                    //   );
                    // } else {
                    //   await Navigator.push(
                    //     context,
                    //     CupertinoPageRoute(
                    //       builder: (context) => StreamSelectionScreen(),
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
