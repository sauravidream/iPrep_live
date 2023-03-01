import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:idream/common/references.dart';
import 'package:idream/custom_widgets/loader.dart';

class ShareAndEarnPage extends StatefulWidget {
  final String? appLevelLanguage;
    const ShareAndEarnPage({Key? key, this.appLevelLanguage}) : super(key: key);

  @override
  _ShareAndEarnPageState createState() => _ShareAndEarnPageState();
}

class _ShareAndEarnPageState extends State<ShareAndEarnPage> {
  bool _dataLoaded = false;
  int? _totalIPrepCash;
  int? _totalInvitedPeopleCount;

  Future getShareAndEarnData() async {
    var _response =
        await shareEarnRepository.fetchNumberOfInvitedPeopleAndEarnedAmount();

    if (_response != null) {
      _totalIPrepCash=_response["balance"]!=null?(int.parse(_response["balance"]['current_amount'])):0;
      // _totalIPrepCash = int.tryParse((_response["balance"]["current_amount"]==null)?0:_response["balance"]["current_amount"]);
      _totalInvitedPeopleCount = ((_response["history"]["referred_to"] == null)
          ? 0
          : _response["history"]["referred_to"].length);
    } else {
      _totalIPrepCash = 0;
      _totalInvitedPeopleCount = 0;
    }
  }

  @override
  void initState() {
    super.initState();
    _totalIPrepCash = 0;
    _totalInvitedPeopleCount = 0;
    getShareAndEarnData().then((value) {
      setState(() {
        _dataLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: false,
            leadingWidth: 36,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding:const EdgeInsets.only(
                  left: 11,
                ),
                child: Image.asset(
                  "assets/images/back_icon.png",
                  height: 25,
                  width: 25,
                ),
              ),
            ),
            title: Text(
              widget.appLevelLanguage == "hindi"
                  ? "ऍप साझा करें और इनाम कमाएँ"
                  : "Share and Earn",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.values[5],
                color: const Color(0xFF212121),
              ),
            ),
          ),
          body: Container(
            color: Colors.white,
            padding:const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: _dataLoaded
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:const EdgeInsets.only(
                              top: 34,
                              bottom: 20,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/earn.png",
                                        height: 23,
                                        width: 23,
                                      ),
                                      const  SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        widget.appLevelLanguage == "hindi"
                                            ? "कुल प्राप्त इनाम"
                                            : "Earned",
                                        style: TextStyle(
                                          color: const Color(0xFF9E9E9E),
                                          fontSize: 12,
                                          fontWeight: FontWeight.values[4],
                                        ),
                                      ),
                                      const    SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/rupee_icon.png",
                                            height: 12,
                                            width: 8,
                                            color: const Color(0xFF212121),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            _totalIPrepCash.toString(),
                                            style: TextStyle(
                                              color:const Color(0xFF212121),
                                              fontSize: 16,
                                              fontWeight: FontWeight.values[5],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 2,
                                  height: 45,
                                  color:const Color(0xFFDEDEDE),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/invitation.png",
                                        height: 23,
                                        width: 23,
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        widget.appLevelLanguage == "hindi"
                                            ? "कुल आमंत्रित मित्र"
                                            : "Friends Invited",
                                        style: TextStyle(
                                          color: const Color(0xFF9E9E9E),
                                          fontSize: 12,
                                          fontWeight: FontWeight.values[4],
                                        ),
                                      ),
                                      const  SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        _totalInvitedPeopleCount.toString(),
                                        style: TextStyle(
                                          color: const Color(0xFF212121),
                                          fontSize: 16,
                                          fontWeight: FontWeight.values[5],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Image.asset(
                              "assets/images/gift_image.png",
                              height: 109,
                              width: 119,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.8,
                                color: const Color(0xFF212121),
                                fontFamily: GoogleFonts.inter().fontFamily,
                              ),
                              children: [
                                TextSpan(
                                  text: (widget.appLevelLanguage == "hindi")
                                      ? "अपने प्रियजनों को केवल तीन सामान्य चरणों में "
                                      : 'Get your dear ones started on the ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.values[4],
                                  ),
                                ),
                                TextSpan(
                                  text: 'iPrep ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.values[5],
                                  ),
                                ),
                                TextSpan(
                                  text: (widget.appLevelLanguage == "hindi")
                                      ? "अपने प्रियजनों को केवल तीन सामान्य चरणों में "
                                      : 'App in just ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.values[4],
                                  ),
                                ),
                                if (widget.appLevelLanguage != "Hindi")
                                  TextSpan(
                                    text: '3 simple steps',
                                    style: TextStyle(
                                      fontWeight: FontWeight.values[5],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const  SizedBox(
                            height: 20,
                          ),
                          shareStepWidget(
                            imagePath: "share_step_1",
                            text: (widget.appLevelLanguage == "hindi")
                                ? "अपने मित्रों को iPrep ऍप डाउनलोड करने  निमंत्रण भेजें"
                                : "Invite your friends to download iPrep",
                          ),
                          Padding(
                            padding:const EdgeInsets.only(
                              left: 15,
                            ),
                            child: Image.asset(
                              "assets/images/line_blue.png",
                              height: 20,
                            ),
                          ),
                          shareStepWidget(
                            imagePath: "share_step_2",
                            text: (widget.appLevelLanguage == "hindi")
                                ? "आपका मित्र अब ऍप को सब्स्क्राइब करता हैं"
                                : "Your friend subscribes to the app",
                          ),
                          Padding(
                            padding:const EdgeInsets.only(
                              left: 15,
                            ),
                            child: Image.asset(
                              "assets/images/line_blue.png",
                              height: 20,
                            ),
                          ),
                          shareStepWidget(
                            imagePath: "share_step_3",
                            text: (widget.appLevelLanguage == "hindi")
                                ? "आपको एवं आपके मित्र दोनों को ही 100 रु का iPrep कैश प्राप्त होता है|"
                                : "They get Rs. 100 as iPrep Cash and you too get the same amount",
                          ),
                        ],
                      ),
                      Padding(
                        padding:const EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: shareAndEarnButton(context: context),
                      ),
                    ],
                  )
                : const Center(child: Loader()),
          ),
        ),
      ),
    );
  }

  Row shareStepWidget({String? imagePath, required String text}) {
    return Row(
      children: [
        Image.asset(
          "assets/images/$imagePath.png",
          height: 35,
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: const Color(0xFF212121),
              fontSize: 14,
              fontWeight: FontWeight.values[4],
            ),
          ),
        ),
      ],
    );
  }
}

shareAndEarnButton({BuildContext? context}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
        primary:const Color(0xFF0077FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        minimumSize: const Size(double.infinity, 60)),
    child: Text(
      "Share iPrep",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.values[4]),
    ),
    onPressed: () async {
      var _deepLinkUrl =
          await shareEarnRepository.prepareDeepLinkForAppDownload();
      await shareEarnRepository.shareContent(
          context: context, content: _deepLinkUrl.toString());
    },
  );
}
