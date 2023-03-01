import 'package:flutter/material.dart';

import 'package:idream/common/references.dart';

class PracticeWellDonePage extends StatelessWidget {
  final String? topicName;
  final String? appLevelLanguage;

  const PracticeWellDonePage({Key? key, this.topicName = "", this.appLevelLanguage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/well_done.png",
                  height: 281,
                  width: 278,
                  fit: BoxFit.fill,
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 65,
                  ),
                  child: Column(
                    children: [
                      Text(
                        appLevelLanguage == "Hindi"
                            ? "प्रशंशनीय प्रदर्शन"
                            : "Well Done!",
                        style: TextStyle(
                            color: const Color(0xFF212121),
                            fontSize: 20,
                            fontWeight: FontWeight.values[5]),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        appLevelLanguage == "Hindi"
                            ? "$topicName में आपने निपुणता प्राप्त कर ली है|"
                            : "You have mastered the Topic MCQ on $topicName.",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: const Color(0xFF666666),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 26,
                      ),
                      startNewTestButton(context, appLevelLanguage),
                      const SizedBox(
                        height: 16,
                      ),
                      InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          // var _deepLinkUrl = await shareEarnRepository
                          //     .prepareDeepLinkForAppDownload();
                          // await shareEarnRepository.shareContent(
                          //     context: context,
                          //     content: _deepLinkUrl.toString());
                        },
                        child: Text(
                          appLevelLanguage == "Hindi" ? "बंद करे" : "Close",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget startNewTestButton(BuildContext _context, String? appLevelLanguage) {
  return Center(
    child: GestureDetector(
      onTap: () {
        Navigator.pop(_context);
      },
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 48,
          maxWidth: 248,
        ),
        decoration: const BoxDecoration(
          color: const Color(0xFF0077FF),
          borderRadius: BorderRadius.all(const Radius.circular(12.0)),
        ),
        child: Center(
          child: Text(
            appLevelLanguage == "Hindi"
                ? "अब अन्य अध्यायों का अभ्यास करें"
                : "Start Practicing another Topic",
            style: TextStyle(
              color: const Color(0xFFFFFFFF),
              fontWeight: FontWeight.values[4],
              fontSize: 14,
            ),
          ),
        ),
      ),
    ),
  );
}
