import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/custom_widgets/custom_tile.dart';
import 'package:idream/custom_widgets/onboarding_bottom_button.dart';
import 'package:idream/model/streams_model.dart';
import 'package:idream/model/user.dart';
import 'package:idream/ui/dashboard/dashboard_page.dart';
import 'package:idream/ui/teacher/dashboard_coach.dart';

class StreamUpdateScreenDashboard extends StatefulWidget {
  final AppUser? updateAppUserInfo;

  const StreamUpdateScreenDashboard({
    Key? key,
    this.updateAppUserInfo,
  }) : super(key: key);

  @override
  StreamUpdateScreenDashboardState createState() =>
      StreamUpdateScreenDashboardState();
}

class StreamUpdateScreenDashboardState
    extends State<StreamUpdateScreenDashboard> {
  String? selectedStream = "";

  @override
  void initState() {
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
          body: Container(
            padding: const EdgeInsets.only(
              bottom: 40,
              left: 18,
              right: 18,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 25,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Image.asset("assets/images/back_icon.png"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(
                        bottom: 30,
                      ),
                      child: Text(
                        "And what is your stream?",
                        style: TextStyle(
                            color: const Color(0xFF212121),
                            fontSize: 16,
                            fontWeight: FontWeight.values[5]),
                      ),
                    ),
                    FutureBuilder(
                        future: streamSelectionRepository.fetchStreams(
                            boardName: widget.updateAppUserInfo!.educationBoard!
                                .toLowerCase(),
                            classID: widget.updateAppUserInfo!.classID),
                        builder: (context, streams) {
                          if (streams.connectionState == ConnectionState.none &&
                              streams.hasData == null) {
                            return Container();
                          } else if (streams.hasData) {
                            List<StreamsModel>? _streamsList =
                                streams.data as List<StreamsModel>?;
                            return ListView.builder(
                                itemCount: _streamsList!.length,
                                padding: const EdgeInsets.all(0),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      if (selectedStream ==
                                          _streamsList[index].streamName) {
                                        setState(() {
                                          selectedStream = "";
                                        });
                                      } else {
                                        setState(() {
                                          selectedStream =
                                              _streamsList[index].streamName;
                                        });
                                      }
                                    },
                                    child: CustomTileWidget(
                                      selected: selectedStream ==
                                              _streamsList[index].streamName
                                          ? true
                                          : false,
                                      leadingWidgetRequired: true,
                                      streamText: _streamsList[index]
                                          .streamName /*"Science"*/,
                                      selectedColor: ((_streamsList[index]
                                                  .streamName ==
                                              'Science')
                                          ? 0xFF46B6E9
                                          : ((_streamsList[index].streamName ==
                                                  'Commerce')
                                              ? 0xFF9fb22D
                                              : 0xFFE39700)),
                                      leadingImagePath:
                                          "assets/images/science.png",
                                      dynamicLeadingImagePath:
                                          _streamsList[index].icon,
                                      checkImagePath:
                                          'assets/images/${((_streamsList[index].streamName == 'Science') ? 'checked_image_blue' : ((_streamsList[index].streamName == 'Commerce') ? 'check_commerce' : 'check_arts'))}.png',
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
                    OnBoardingBottomButton(
                      buttonText: "Confirm",
                      buttonColor:
                          selectedStream!.length > 0 ? 0xFF0077FF : 0xFFDEDEDE,
                      onPressed: () async {
                        if (selectedStream!.length > 0) {
                          widget.updateAppUserInfo!.stream = selectedStream;

                          await dashboardRepository.updateUserInfoFromDashboard(
                            updatedUserInfo: widget.updateAppUserInfo!,
                          );
                          // Navigator.pop(context);
                          // Navigator.pop(context);
                          await Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => ((!usingIprepLibrary)
                                    ? const DashboardScreen()
                                    : const DashboardCoach(
                                        selectedTabIndex: 1,
                                      ))),
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          SnackbarMessages.showErrorSnackbar(context,
                              error: Constants.streamAlert);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
