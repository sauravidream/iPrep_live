import 'package:flutter/material.dart';

import 'package:idream/common/constants.dart';
import 'package:idream/common/global_variables.dart';
import 'package:idream/common/references.dart';
import 'package:idream/common/shared_preference.dart';
import 'package:idream/common/snackbar_messages.dart';
import 'package:idream/custom_widgets/custom_tile.dart';
import 'package:idream/custom_widgets/onboarding_bottom_button.dart';
import 'package:idream/model/app_language.dart';

class AppLevelLanguageSelectionScreen extends StatefulWidget {
  final bool isCoachSection;

  const AppLevelLanguageSelectionScreen({Key? key, this.isCoachSection = false})
      : super(key: key);

  @override
  _AppLevelLanguageSelectionScreenState createState() =>
      _AppLevelLanguageSelectionScreenState();
}

class _AppLevelLanguageSelectionScreenState
    extends State<AppLevelLanguageSelectionScreen> {
  bool _loadPage = false;

  Future initializeAppLevelLanguage() async {
    String? _selectedAppLanguage = await getStringValuesSF('language');
    if (_selectedAppLanguage == null) {
      selectedAppLanguage = 'english';
    } else {
      selectedAppLanguage = _selectedAppLanguage;
    }
  }

  @override
  void initState() {
    super.initState();

    initializeAppLevelLanguage().then((value) {
      setState(() {
        _loadPage = true;
      });
    });
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
            child: _loadPage
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.isCoachSection)
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Image.asset(
                                        "assets/images/back_icon.png"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      Container(
                        height: 0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            selectedAppLanguage!.toLowerCase() == 'hindi'
                                ? "अपनी पसंदीदा भाषा चुनें"
                                : "Choose your preferred language",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF000C1A),
                              fontSize: 16,
                              fontWeight: FontWeight.values[5],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // FutureBuilder<List<AppLanguage>>(
                          //   future: onBoardingRepository.fetchAppLanguages(),
                          //   builder: (context, languages) {
                          //     if (languages.connectionState ==
                          //             ConnectionState.none &&
                          //         languages.hasData == null) {
                          //       return Container();
                          //     } else if (languages.hasData) {
                          //       return ListView.builder(
                          //           itemCount: languages.data!.length,
                          //           padding: const EdgeInsets.all(0),
                          //           shrinkWrap: true,
                          //           itemBuilder: (context, index) {
                          //             if (languages.data!.length == 1) {
                          //               selectedAppLanguage = "English";
                          //             }
                          //             return getLanguageTile(
                          //               list: languages.data![index],
                          //               listLength: languages.data!.length,
                          //             );
                          //           });
                          //     } else {
                          //       return Container(
                          //         alignment: Alignment.center,
                          //         child: const Text("Loading..."),
                          //       );
                          //     }
                          //   },
                          // ),
                          FutureBuilder<LanguageModel?>(
                            future: onBoardingRepository.fetchAllLanguages(),
                            builder: (BuildContext context,
                                AsyncSnapshot<LanguageModel?> language) {
                              Widget languageWidget;
                              if (language.hasData) {
                                String? selectedLanguage =
                                    language.data!.language!.first.id;
                                languageWidget = LanguageTile(
                                  language: language.data!.language,
                                  selectedLanguage: selectedLanguage,
                                  isOnBoarding: true,
                                );
                              } else if (!language.hasData) {
                                languageWidget = Container(
                                  alignment: Alignment.center,
                                  child: const Text("Loading..."),
                                );
                              } else if (language.hasError) {
                                languageWidget = Container(
                                  alignment: Alignment.center,
                                  child: const Text("Something went wrong..."),
                                );
                              } else {
                                languageWidget = Container(
                                  alignment: Alignment.center,
                                  child: const Text("Something went wrong..."),
                                );
                              }
                              return languageWidget;
                            },
                          ),

                          OnBoardingBottomButton(
                            buttonText: widget.isCoachSection
                                ? selectedAppLanguage!.toLowerCase() == 'hindi'
                                    ? "प्रस्तुत करना"
                                    : "Submit"
                                : selectedAppLanguage!.toLowerCase() == 'hindi'
                                    ? "आगे बढ़ें"
                                    : "Continue",
                            onPressed: () async {
                              if (selectedAppLanguage != null) {
                                String? userID =
                                    await getStringValuesSF("userID");
                                await userRepository.saveUserDetailToLocal(
                                    'language',
                                    selectedAppLanguage!.toLowerCase());
                                if (widget.isCoachSection) {
                                  appUser!.language =
                                      selectedAppLanguage!.toLowerCase();
                                  await userRepository
                                      .updateUserProfileWithSelectedLanguage(
                                          language: selectedAppLanguage!
                                              .toLowerCase());
                                  Navigator.pop(context);
                                  return;
                                }
                                if (userID != null) {
                                  Navigator.pop(context);
                                  // await Navigator.pushAndRemoveUntil(
                                  //   context,
                                  //   CupertinoPageRoute(
                                  //     builder: (context) =>
                                  //         LoginScreen(
                                  //       // appLevelLanguage: selectedAppLanguage,
                                  //     ),
                                  //   ),
                                  //   (Route<dynamic> route) => false,
                                  // );
                                } else {
                                  //TODO: Here we are changing the flow....

                                  Navigator.pop(context);

                                  // await Navigator.pushAndRemoveUntil(
                                  //   context,
                                  //   CupertinoPageRoute(
                                  //     builder: (context) =>
                                  //         LoginScreen(
                                  //       // appLevelLanguage: selectedAppLanguage,
                                  //     ),
                                  //   ),
                                  //   (Route<dynamic> route) => false,
                                  // );
                                  // await Navigator.pushAndRemoveUntil(
                                  //   context,
                                  //   CupertinoPageRoute(
                                  //     builder: (context) => LoginScreen(),
                                  //   ),
                                  //   (Route<dynamic> route) => false,
                                  // );
                                }
                              } else {
                                SnackbarMessages.showErrorSnackbar(context,
                                    error: Constants.languageSelectionAlert);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Color(0xFF3399FF),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  getLanguageTile({required AppLanguage list, int? listLength}) {
    return GestureDetector(
      onTap: () {
        if ((listLength! > 1)) {
          setState(() {
            list.isSelected = !list.isSelected;
            if (list.isSelected) selectedAppLanguage = list.languageName;
          });
        }
      },
      child: CustomTileWidget(
        selected: (listLength == 1)
            ? true
            : (list.languageName == selectedAppLanguage ? true : false),
        streamText: ((list.languageName == "English")
            ? "English is my preferred language"
            : (list.languageName == "Hindi"
                ? "हिंदी मेरी पसंदीदा भाषा है"
                : list.languageName)),
        leadingWidgetRequired: true,
        leadingImagePath: ((list.languageName == "English")
            ? "assets/images/english_char.png"
            : ((list.languageName == "Hindi")
                ? "assets/images/hindi_char.png"
                : null)),
        selectedColor: 0xFF22C59B,
      ),
    );
  }
}

// class CreateDynamicList extends StatefulWidget {
//   final AppLanguage list;
//   final int listLength;
//   CreateDynamicList({this.list, this.listLength});
//
//   @override
//   _CreateDynamicListState createState() => _CreateDynamicListState();
// }
//
// class _CreateDynamicListState extends State<CreateDynamicList> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         if ((widget.listLength > 1)) {
//           setState(() {
//             widget.list.isSelected = !widget.list.isSelected;
//             if (widget.list.isSelected)
//               selectedAppLanguage = widget.list.languageName;
//           });
//         }
//       },
//       child: CustomTileWidget(
//         selected: (widget.listLength == 1) ? true : widget.list.isSelected,
//         streamText: ((widget.list.languageName == "English")
//             ? "English is my preferred language"
//             : (widget.list.languageName == "Hindi"
//                 ? "हिंदी मेरी पसंदीदा भाषा है"
//                 : widget.list.languageName)),
//         leadingWidgetRequired: true,
//         leadingImagePath: ((widget.list.languageName == "English")
//             ? "assets/images/english_char.png"
//             : ((widget.list.languageName == "Hindi")
//                 ? "assets/images/hindi_char.png"
//                 : null)),
//         selectedColor: 0xFF22C59B,
//       ),
//     );
//   }
// }
