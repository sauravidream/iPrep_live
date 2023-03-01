import 'package:flutter/material.dart';
import 'package:idream/common/constants.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/custom_widgets/custom_tile.dart';
import 'package:idream/custom_widgets/onboarding_bottom_button.dart';
import 'package:idream/model/streams_model.dart';
import 'package:idream/ui/dashboard/dashboard_page.dart';
import 'package:flutter/cupertino.dart';
import '../../common/global_variables.dart';

class StreamSelectionScreen extends StatefulWidget {
  const StreamSelectionScreen({Key? key}) : super(key: key);

  @override
  StreamSelectionScreenState createState() => StreamSelectionScreenState();
}

class StreamSelectionScreenState extends State<StreamSelectionScreen> {
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(
                        bottom: 30,
                      ),
                      child: Text(
                        selectedAppLanguage!.toLowerCase() == "hindi"
                            ? "और आपकी स्ट्रीम क्या है?"
                            : "And what is your stream?",
                        style: TextStyle(
                            color: const Color(0xFF212121),
                            fontSize: 16,
                            fontWeight: FontWeight.values[5]),
                      ),
                    ),

                    FutureBuilder(
                        future: streamSelectionRepository.fetchStreams(),
                        builder: (context, streams) {
                          if (streams.connectionState == ConnectionState.none &&
                              !streams.hasData) {
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
                                        await removeStringToSF("stream");
                                      } else {
                                        setState(() {
                                          selectedStream =
                                              _streamsList[index].streamName;
                                        });
                                        await userRepository
                                            .saveUserDetailToLocal("stream",
                                                _streamsList[index].streamID!);
                                      }
                                    },
                                    child: CustomTileWidget(
                                      selected: selectedStream ==
                                              _streamsList[index].streamName
                                          ? true
                                          : false,
                                      leadingWidgetRequired: true,
                                      streamText: _streamsList[index]
                                          .streamName, //0xFF46B6E9
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

                    // GestureDetector(
                    //   onTap: () async {
                    //     if (selectedStream == "Science") {
                    //       setState(() {
                    //         selectedStream = "";
                    //       });
                    //       await removeStringToSF("stream");
                    //     } else {
                    //       setState(() {
                    //         selectedStream = "Science";
                    //       });
                    //       await userRepository.saveUserDetailToLocal(
                    //           "stream", "NonMedical_Medical");
                    //     }
                    //   },
                    //   child: CustomTileWidget(
                    //     selected: selectedStream == "Science" ? true : false,
                    //     leadingWidgetRequired: true,
                    //     streamText: "Science",
                    //     selectedColor: 0xFF46B6E9,
                    //     leadingImagePath: "assets/images/science.png",
                    //   ),
                    // ),
                    // GestureDetector(
                    //   onTap: () async {
                    //     if (selectedStream == "Commerce") {
                    //       setState(() {
                    //         selectedStream = "";
                    //       });
                    //       await removeStringToSF("stream");
                    //     } else {
                    //       setState(() {
                    //         selectedStream = "Commerce";
                    //       });
                    //       await userRepository.saveUserDetailToLocal(
                    //           "stream", "Commerce");
                    //     }
                    //   },
                    //   child: CustomTileWidget(
                    //     selected: selectedStream == "Commerce" ? true : false,
                    //     leadingWidgetRequired: true,
                    //     streamText: "Commerce",
                    //     selectedColor: 0xFF46B6E9,
                    //     leadingImagePath: "assets/images/commerce.png",
                    //   ),
                    // ),
                    // GestureDetector(
                    //   onTap: () async {
                    //     if (selectedStream == "Arts") {
                    //       setState(() {
                    //         selectedStream = "";
                    //       });
                    //       await removeStringToSF("stream");
                    //     } else {
                    //       setState(() {
                    //         selectedStream = "Arts";
                    //       });
                    //       await userRepository.saveUserDetailToLocal(
                    //           "stream", "Arts");
                    //     }
                    //   },
                    //   child: CustomTileWidget(
                    //     selected: selectedStream == "Arts" ? true : false,
                    //     leadingWidgetRequired: true,
                    //     streamText: "Arts",
                    //     selectedColor: 0xFF46B6E9,
                    //     leadingImagePath: "assets/images/arts.png",
                    //   ),
                    // ),
                    OnBoardingBottomButton(
                      buttonText: selectedAppLanguage!.toLowerCase() == "hindi"
                          ? "आगे बढ़ें"
                          : "Learn Now",
                      buttonColor:
                          selectedStream!.length > 0 ? 0xFF0077FF : 0xFFDEDEDE,
                      onPressed: () async {
                        if (selectedStream!.length > 0) {
                          await userRepository.saveUserDetailToLocal(
                              "onBoarding", "Completed");

                          //Save remaining user details
                          await userRepository
                              .saveUserInfoPostSuccessfulOnBoarding();

                          //Save Current Device Info
                          await userRepository.saveCurrentDeviceInfo();
                          if (!mounted) return;
                          await Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const DashboardScreen(
                                firstTimeLanded: true,
                              ),
                            ),
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
